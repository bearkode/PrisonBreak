/*
 *  PBScene.m
 *  PBKit
 *
 *  Created by camelkode on 13. 4. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBScene.h"
#import "PBContext.h"
#import "PBGLObjectManager.h"
#import "PBTextureUtils.h"
#import "PBNodePrivate.h"


@implementation PBScene
{
    id     mDelegate;
    CGSize mSceneSize;
    GLuint mTextureHandle;
    
    GLuint mFramebuffer;
    GLuint mDepthRenderbuffer;
    BOOL   mGeneratedBuffer;
}


@synthesize delegate        = mDelegate;
@synthesize sceneSize       = mSceneSize;
@synthesize textureHandle   = mTextureHandle;
@synthesize generatedBuffer = mGeneratedBuffer;


#pragma mark -


- (id)initWithDelegate:(id)aDelegate
{
    self = [super init];
    if (self)
    {
        mDelegate = aDelegate;
    }
    
    return self;
}


- (void)dealloc
{
    [self destroyBuffer];
    [super dealloc];
}


#pragma mark -


- (BOOL)createBuffer
{
    __block BOOL sResult = YES;
    [PBContext performBlockOnMainThread:^{
        mGeneratedBuffer = YES;
        glGenFramebuffers(1, &mFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, mFramebuffer);
        
        if (mTextureHandle)
        {
            PBTextureRelease(mTextureHandle);
        }
        mTextureHandle = PBTextureCreate();
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, mSceneSize.width, mSceneSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, mTextureHandle, 0);
        
        
        glGenRenderbuffers(1, &mDepthRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, mDepthRenderbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, mSceneSize.width, mSceneSize.height);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, mDepthRenderbuffer);
        
        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
        {
            NSLog(@"failed to make framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
            sResult          = NO;
            mGeneratedBuffer = NO;
        }
    }];
    
    return sResult;
}


- (void)destroyBuffer
{
    [PBContext performBlockOnMainThread:^{
        [[PBGLObjectManager sharedManager] deleteFramebuffer:mFramebuffer];
        [[PBGLObjectManager sharedManager] deleteFramebuffer:mDepthRenderbuffer];
        
        mFramebuffer       = 0;
        mDepthRenderbuffer = 0;
        
        PBTextureRelease(mTextureHandle);
        mTextureHandle     = 0;
        mGeneratedBuffer   = NO;
    }];
}


#pragma mark -


- (void)resetRenderBuffer
{
    [self destroyBuffer];
    [self createBuffer];
}


- (void)bindBuffer
{
    glBindFramebuffer(GL_FRAMEBUFFER, mFramebuffer);
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"failed to make framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
}


- (void)performSceneDelegatePhase:(PBSceneDelegatePhase)aPhase
{
    switch (aPhase)
    {
        case kPBSceneDelegatePhaseWillUpdate:
            if ([mDelegate respondsToSelector:@selector(pbSceneWillUpdate:)])
            {
                [mDelegate pbSceneWillUpdate:self];
            }
            break;
        case kPBSceneDelegatePhaseDidUpdate:
            if ([mDelegate respondsToSelector:@selector(pbSceneDidUpdate:)])
            {
                [mDelegate pbSceneDidUpdate:self];
            }
            break;
        case kPBSceneDelegatePhaseWillRender:
            if ([mDelegate respondsToSelector:@selector(pbSceneWillRender:)])
            {
                [mDelegate pbSceneWillRender:self];
            }
            break;
        case kPBSceneDelegatePhaseDidRender:
            if ([mDelegate respondsToSelector:@selector(pbSceneDidRender:)])
            {
                [mDelegate pbSceneDidRender:self];
            }
            break;
        default:
            break;
    }
}


- (void)performSceneTapDelegatePhase:(PBSceneTapDelegatePhase)aPhase canvasPoint:(CGPoint)aCanvasPoint
{
    switch (aPhase)
    {
        case kPBSceneTapDelegatePhaseTap:
            if ([mDelegate respondsToSelector:@selector(pbScene:didTapCanvasPoint:)])
            {
                [mDelegate pbScene:self didTapCanvasPoint:aCanvasPoint];
            }
            break;
        case kPBSceneTapDelegatePhaseLongTap:
            if ([mDelegate respondsToSelector:@selector(pbScene:didLongTapCanvasPoint:)])
            {
                [mDelegate pbScene:self didLongTapCanvasPoint:aCanvasPoint];
            }
            break;
        default:
            break;
    }
}


- (PBMatrix)projection
{
    return [[self mesh] projection];
}


@end
