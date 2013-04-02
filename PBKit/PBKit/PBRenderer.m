/*
 *  PBRenderer.m
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 25..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "PBKit.h"
#import "PBException.h"
#import "PBGLObjectManager.h"
#import "PBMeshRenderer.h"


@implementation PBRenderer
{
    GLint           mDisplayWidth;
    GLint           mDisplayHeight;
    
    GLuint          mViewFramebuffer;
    GLuint          mViewRenderbuffer;
    EAGLContext    *mContext;
    
    PBMatrix        mProjection;
    NSMutableArray *mLayersInSelectionMode;
}


#pragma mark -


@synthesize displayWidth  = mDisplayWidth;
@synthesize displayHeight = mDisplayHeight;
@synthesize projection    = mProjection;


#pragma mark -


- (void)resetRenderBufferWithLayer:(CAEAGLLayer *)aLayer
{
    [self destroyBuffer];
    [self createBufferWithLayer:aLayer];
}


- (BOOL)createBufferWithLayer:(CAEAGLLayer *)aLayer
{
    __block BOOL sResult = YES;
    
    [PBContext performBlockOnMainThread:^{
        glGenRenderbuffers(1, &mViewRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, mViewRenderbuffer);
        [mContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)aLayer];
        
        glGenFramebuffers(1, &mViewFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, mViewFramebuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, mViewRenderbuffer);
        
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &mDisplayWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &mDisplayHeight);
        
        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
        {
            NSLog(@"failed to make framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
            sResult = NO;
        }
    }];
    
    return sResult;
}


- (void)destroyBuffer
{
    [PBContext performBlockOnMainThread:^{
        [[PBGLObjectManager sharedManager] deleteFramebuffer:mViewFramebuffer];
        [[PBGLObjectManager sharedManager] deleteRenderbuffer:mViewRenderbuffer];
        
        mViewFramebuffer = 0;
        mViewRenderbuffer = 0;
    }];
}


- (void)bindBuffer
{
    glBindRenderbuffer(GL_RENDERBUFFER, mViewRenderbuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, mViewFramebuffer);
}


- (void)clearBackgroundColor:(PBColor *)aColor
{
    glViewport(0, 0, mDisplayWidth, mDisplayHeight);
    glClearColor(aColor.red, aColor.green, aColor.blue, aColor.alpha);
    glClear(GL_COLOR_BUFFER_BIT);
}


#pragma mark -


- (void)render:(PBLayer *)aLayer
{
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    [[aLayer mesh] setProjection:mProjection];
    [aLayer push];
    [[PBMeshRenderer sharedManager] render];
    glDisable(GL_BLEND);
}


- (void)renderForSelection:(PBLayer *)aLayer
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [[PBMeshRenderer sharedManager] setSelectionMode:YES];
    [aLayer pushSelectionWithRenderer:self];
    [[PBMeshRenderer sharedManager] render];
    [[PBMeshRenderer sharedManager] setSelectionMode:NO];
    glDisable(GL_BLEND);
}


- (void)presentRenderBuffer
{
    [mContext presentRenderbuffer:GL_RENDERBUFFER];
}


- (void)beginSelectionMode
{
    [mLayersInSelectionMode autorelease];
    mLayersInSelectionMode = [[NSMutableArray alloc] init];
}


- (void)endSelectionMode
{
    [mLayersInSelectionMode release];
    mLayersInSelectionMode = nil;
}


- (PBLayer *)layerAtPoint:(CGPoint)aPoint
{
    if ((aPoint.x > mDisplayWidth) || (aPoint.y > mDisplayHeight))
    {
        return nil;
    }
    
    if (mLayersInSelectionMode)
    {
        __block NSUInteger sIndex;
        
        [PBContext performBlockOnMainThread:^{
            GLubyte sColor[4];
            
            glReadPixels(aPoint.x, mDisplayHeight - aPoint.y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, sColor);
            sIndex = (sColor[0] << 16) + (sColor[1] << 8) + sColor[2] - 1;
        }];
        
        if (sIndex < [mLayersInSelectionMode count])
        {
            return [mLayersInSelectionMode objectAtIndex:sIndex];
        }
    }
    
    return nil;
}


- (PBLayer *)selectedLayerAtPoint:(CGPoint)aPoint
{
    PBLayer *sLayer = [self layerAtPoint:aPoint];
    
    while (sLayer && ([sLayer isSelectable] == NO))
    {
        sLayer = [sLayer superlayer];
    }
    
    return sLayer;
}


- (void)addLayerForSelection:(PBLayer *)aLayer
{
    NSUInteger sCount = 1;
    GLubyte    sRed;
    GLubyte    sGreen;
    GLubyte    sBlue;
    
    [mLayersInSelectionMode addObject:aLayer];
    
    sCount = [mLayersInSelectionMode count];
    sRed   = (sCount >> 16) & 0xff;
    sGreen = (sCount >> 8)  & 0xff;
    sBlue  = (sCount)       & 0xff;
    
    [aLayer setSelectionColorWithRed:(sRed   & 0xff) / 255.0
                               green:(sGreen & 0xff) / 255.0
                                blue:(sBlue  & 0xff) / 255.0];
}


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mContext = [PBContext context];
        [EAGLContext setCurrentContext:mContext];
    }
    
    return self;
}


- (void)dealloc
{
    [self destroyBuffer];
    [mLayersInSelectionMode release];
    
    [super dealloc];
}


@end
