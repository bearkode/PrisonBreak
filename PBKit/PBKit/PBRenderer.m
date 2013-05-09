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
    
    GLuint          mFramebuffer;
    GLuint          mColorRenderbuffer;
    GLuint          mDepthRenderBuffer;
    
    BOOL            mDepthTestingEnabled;
    
    EAGLContext    *mContext;
    
    PBMatrix        mProjection;
    BOOL            mDidProjectionChange;
    NSMutableArray *mLayersInSelectionMode;
}


#pragma mark -


@synthesize displayWidth        = mDisplayWidth;
@synthesize displayHeight       = mDisplayHeight;
@synthesize depthTestingEnabled = mDepthTestingEnabled;


#pragma mark -

- (void)setProjection:(PBMatrix)aProjection
{
    mProjection          = aProjection;
    mDidProjectionChange = YES;
}


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
        // frame buffer
        glGenFramebuffers(1, &mFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, mFramebuffer);
        
        // color render buffer
        glGenRenderbuffers(1, &mColorRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, mColorRenderbuffer);
        [mContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)aLayer];
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, mColorRenderbuffer);
        
        // get render buffer size
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &mDisplayWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &mDisplayHeight);
        
        if (mDepthTestingEnabled)
        {
            // depth render buffer
            glGenRenderbuffers(1, &mDepthRenderBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, mDepthRenderBuffer);
            glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, mDisplayWidth, mDisplayHeight);
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, mDepthRenderBuffer);
            
            glEnable(GL_DEPTH_TEST);
            glDepthFunc(GL_GEQUAL);
            glClearDepthf(0.0f);
        }
        else
        {
            glDisable(GL_DEPTH_TEST);
        }
        
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
        [[PBGLObjectManager sharedManager] deleteFramebuffer:mFramebuffer];
        [[PBGLObjectManager sharedManager] deleteRenderbuffer:mColorRenderbuffer];
        [[PBGLObjectManager sharedManager] deleteRenderbuffer:mDepthRenderBuffer];
        
        mFramebuffer       = 0;
        mColorRenderbuffer = 0;
        mDepthRenderBuffer = 0;
    }];
}


- (void)bindBuffer
{
    glBindRenderbuffer(GL_RENDERBUFFER, mColorRenderbuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, mFramebuffer);
}


- (void)clearBackgroundColor:(PBColor *)aColor
{
    glViewport(0, 0, mDisplayWidth, mDisplayHeight);
    glClearColor(aColor.red, aColor.green, aColor.blue, aColor.alpha);
    
    if (mDepthTestingEnabled)
    {
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    }
    else
    {
        glClear(GL_COLOR_BUFFER_BIT);
    }
}


#pragma mark -


- (void)render:(PBLayer *)aLayer
{
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    if (mDidProjectionChange)
    {
        [[aLayer mesh] setProjection:mProjection];
        mDidProjectionChange = NO;
    }
    
    [aLayer push];
    [[PBMeshRenderer sharedManager] render];
    glDisable(GL_BLEND);
}


- (void)renderForSelection:(PBLayer *)aLayer
{
    [[PBMeshRenderer sharedManager] setSelectionMode:YES];
    [aLayer pushSelectionWithRenderer:self];
    [[PBMeshRenderer sharedManager] render];
    [[PBMeshRenderer sharedManager] setSelectionMode:NO];
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
