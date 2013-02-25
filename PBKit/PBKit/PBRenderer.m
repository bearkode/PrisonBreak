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


@implementation PBRenderer
{
    PBProgram      *mProgram;
    GLint           mDisplayWidth;
    GLint           mDisplayHeight;

    GLuint          mViewFramebuffer;
    GLuint          mViewRenderbuffer;
    EAGLContext    *mContext;
    
    PBMatrix4       mProjection;
    NSMutableArray *mRenderablesInSelectionMode;
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
        if (mViewFramebuffer)
        {
            glDeleteFramebuffers(1, &mViewFramebuffer);
            mViewFramebuffer = 0;
        }

        if (mViewRenderbuffer)
        {
            glDeleteRenderbuffers(1, &mViewRenderbuffer);
            mViewRenderbuffer = 0;
        }
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


- (void)bindShader
{
    mProgram = [[PBProgramManager sharedManager] bundleProgram];
    [mProgram use];
    [mProgram bindLocation];
}


#pragma mark -


- (void)render:(PBRenderable *)aRenderable
{
    [PBContext performBlockOnMainThread:^{
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        glEnable(GL_BLEND);
        glEnable(GL_TEXTURE_2D);
        
        [mProgram use];
        
        [aRenderable setProjection:mProjection];
        [aRenderable setProgram:mProgram];
        [aRenderable performRender];
        
        glDisable(GL_BLEND);
        glDisable(GL_TEXTURE_2D);
        
        [EAGLContext setCurrentContext:mContext];
        [mContext presentRenderbuffer:GL_RENDERBUFFER];
    }];
}


- (void)renderForSelection:(PBRenderable *)aRenderable
{
    [PBContext performBlockOnMainThread:^{
        glEnable(GL_BLEND);
        glEnable(GL_TEXTURE_2D);
        
        glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);

        [aRenderable performSelectionWithRenderer:self];
        
        glDisable(GL_BLEND);
        glDisable(GL_TEXTURE_2D);
    }];
}


- (void)beginSelectionMode
{
    mRenderablesInSelectionMode = [[NSMutableArray alloc] init];
}


- (void)endSelectionMode
{
    [mRenderablesInSelectionMode release];
    mRenderablesInSelectionMode = nil;
}


- (PBRenderable *)renderableAtPoint:(CGPoint)aPoint
{
    if ((aPoint.x > mDisplayWidth) || (aPoint.y > mDisplayHeight))
    {
        return nil;
    }
    
    if (mRenderablesInSelectionMode)
    {
        __block NSUInteger sIndex;

        [PBContext performBlockOnMainThread:^{
            GLubyte sColor[4];

            glReadPixels(aPoint.x, mDisplayHeight - aPoint.y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, sColor);
            sIndex = (sColor[0] << 16) + (sColor[1] << 8) + sColor[2] - 1;
        }];

        if (sIndex < [mRenderablesInSelectionMode count])
        {
            return [mRenderablesInSelectionMode objectAtIndex:sIndex];
        }
    }
    
    return nil;
}


- (PBRenderable *)selectedRenderableAtPoint:(CGPoint)aPoint
{
    PBRenderable *sRenderable = [self renderableAtPoint:aPoint];
    
    while (sRenderable && ([sRenderable isSelectable] == NO))
    {
        sRenderable = [sRenderable superrenderable];
    }
    
    return sRenderable;
}


- (void)addRenderableForSelection:(PBRenderable *)aRenderable
{
    NSUInteger sCount = 1;
    GLubyte    sRed;
    GLubyte    sGreen;
    GLubyte    sBlue;
    
    [mRenderablesInSelectionMode addObject:aRenderable];
    
    sCount = [mRenderablesInSelectionMode count];
    sRed   = (sCount >> 16) & 0xff;
    sGreen = (sCount >> 8)  & 0xff;
    sBlue  = (sCount)       & 0xff;
    
    [aRenderable setSelectionColorWithRed:(sRed   & 0xff) / 255.0
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

        mRenderablesInSelectionMode = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mRenderablesInSelectionMode release];
    
    [super dealloc];
}


@end
