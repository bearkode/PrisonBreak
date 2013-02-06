/*
 *  PBRenderer.m
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 25..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "PBKit.h"


@implementation PBRenderer
{
    GLuint       mViewFramebuffer;
    GLuint       mViewRenderbuffer;
    EAGLContext *mContext;
}


#pragma mark -


@synthesize displayWidth  = mDisplayWidth;
@synthesize displayHeight = mDisplayHeight;


#pragma mark -


- (void)resetRenderBufferWithLayer:(CAEAGLLayer *)aLayer
{
    [self destroyBuffer];
    [self createBufferWithLayer:aLayer];
    [self generateProjectionMatrix];
}


- (BOOL)createBufferWithLayer:(CAEAGLLayer *)aLayer
{
    [PBContext performBlock:^{
        glGenRenderbuffers(1, &mViewRenderbuffer);
    }];

    glBindRenderbuffer(GL_RENDERBUFFER, mViewRenderbuffer);
    [mContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)aLayer];
    
    [PBContext performBlock:^{
        glGenFramebuffers(1, &mViewFramebuffer);
    }];
    
    glBindFramebuffer(GL_FRAMEBUFFER, mViewFramebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, mViewRenderbuffer);
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &mDisplayWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &mDisplayHeight);
    
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"failed to make framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        return NO;
    }
    
    return YES;
}


- (void)destroyBuffer
{
    if (mViewFramebuffer)
    {
        [PBContext performBlock:^{
            glDeleteFramebuffers(1, &mViewFramebuffer);
            mViewFramebuffer = 0;
        }];
    }

    if (mViewRenderbuffer)
    {
        [PBContext performBlock:^{
            glDeleteRenderbuffers(1, &mViewRenderbuffer);
            mViewRenderbuffer = 0;
        }];
    }
}


- (void)bindingBuffer
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


- (void)generateProjectionMatrix
{
#if (1)
    mProjection = [PBTransform multiplyOrthoMatrix:PBMatrix4Identity
                                              left:-(mDisplayWidth / 2)
                                             right:(mDisplayWidth / 2) 
                                            bottom:-(mDisplayHeight / 2)
                                               top:(mDisplayHeight / 2)
                                              near:-1000 far:1000];
#else
    mProjection = [PBTransform multiplyOrthoMatrix:PBMatrix4Identity
                                              left:0
                                             right:mDisplayWidth
                                            bottom:0
                                               top:mDisplayHeight
                                              near:-1000 far:1000];
#endif
}


- (void)setProjectionMatrix:(PBMatrix4)aMatrix
{
    mProjection = aMatrix;
}


#pragma mark -


- (void)display:(PBRenderable *)aRenderable
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    
    [aRenderable performRenderingWithProjection:mProjection];
    
    glDisable(GL_BLEND);
    
    [EAGLContext setCurrentContext:mContext];
    [mContext presentRenderbuffer:GL_RENDERBUFFER];
    glFlush();
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
    [super dealloc];
}


@end
