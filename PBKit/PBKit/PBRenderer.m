/*
 *  PBRenderer.m
 *  PBKit
 *
 *  Created by sshanks on 13. 1. 25..
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


@synthesize displayWidth     = mDisplayWidth;
@synthesize displayHeight    = mDisplayHeight;


#pragma mark -


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


#pragma mark -


- (BOOL)createBufferWithLayer:(CAEAGLLayer *)aLayer
{
    glGenRenderbuffers(1, &mViewRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, mViewRenderbuffer);
    [mContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)aLayer];
    
    glGenFramebuffers(1, &mViewFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, mViewFramebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, mViewRenderbuffer);
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &mDisplayWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &mDisplayHeight);
    
    if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"failed to make framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        return NO;
    }
    
    return YES;
}


- (void)destroyBuffer
{
    glDeleteFramebuffers(1, &mViewFramebuffer);
    mViewFramebuffer = 0;
    glDeleteRenderbuffers(1, &mViewRenderbuffer);
    mViewRenderbuffer = 0;
}


#pragma mark -


- (void)displayView:(PBView *)aView
    backgroundColor:(PBColor *)aColor
           delegate:(id)aDelegate
           selector:(SEL)aSelector
{
    
    if([aDelegate respondsToSelector:aSelector])
    {
        [self bindingBuffer];
        [self clearBackgroundColor:aColor];
        
        glEnable(GL_BLEND);
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        
        [aDelegate performSelector:aSelector withObject:nil];
        [[aView superRenderable] rendering];
        
        glDisable(GL_BLEND);
        
        [EAGLContext setCurrentContext:mContext];
        [mContext presentRenderbuffer:GL_RENDERBUFFER];
        glFlush();
    }
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
