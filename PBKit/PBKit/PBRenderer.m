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
#import "PBTextureUtils.h"


@implementation PBRenderer
{
    CGSize          mRenderBufferSize;
    
    GLuint          mFramebuffer;
    GLuint          mColorRenderbuffer;
    GLuint          mDepthRenderbuffer;
    BOOL            mDepthTestingEnabled;
    
    GLuint          mOffscreenFramebuffer;
    GLuint          mOffscreenColorRenderbuffer;
    GLuint          mOffscreenDepthRenderbuffer;
    GLuint          mOffscreenTextureID;
    
    EAGLContext    *mContext;
    
    PBMatrix        mProjection;
    BOOL            mDidProjectionChange;
    NSMutableArray *mNodesInSelectionMode;
}


#pragma mark -


@synthesize renderBufferSize       = mRenderBufferSize;
@synthesize depthTestingEnabled    = mDepthTestingEnabled;
@synthesize offscreenTextureID     = mOffscreenTextureID;


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
    
    [self destroyOffscreenBuffer];
    [self createOffscreenBuffer];
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
        GLint sDisplayWidth;
        GLint sDisplayHeight;
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &sDisplayWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &sDisplayHeight);
        mRenderBufferSize = CGSizeMake(sDisplayWidth, sDisplayHeight);
        
        if (mDepthTestingEnabled)
        {
            // depth render buffer
            glGenRenderbuffers(1, &mDepthRenderbuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, mDepthRenderbuffer);
            glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, mRenderBufferSize.width, mRenderBufferSize.height);
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, mDepthRenderbuffer);
            
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
        [[PBGLObjectManager sharedManager] deleteRenderbuffer:mDepthRenderbuffer];
        
        mFramebuffer       = 0;
        mColorRenderbuffer = 0;
        mDepthRenderbuffer = 0;
    }];
}


- (void)bindBuffer
{
    glBindRenderbuffer(GL_RENDERBUFFER, mColorRenderbuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, mFramebuffer);
}


- (BOOL)createOffscreenBuffer
{
    __block BOOL sResult = YES;
    [PBContext performBlockOnMainThread:^{

        glGenFramebuffers(1, &mOffscreenFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, mOffscreenFramebuffer);

    
        glGenRenderbuffers(1, &mOffscreenColorRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, mOffscreenColorRenderbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8_OES, mRenderBufferSize.width, mRenderBufferSize.height);
//        [mContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)mEAGLLayer];
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, mOffscreenColorRenderbuffer);
    
        if (mOffscreenTextureID)
        {
            PBTextureRelease(mOffscreenTextureID);
        }
        mOffscreenTextureID = PBTextureCreate();
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, mRenderBufferSize.width, mRenderBufferSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, mOffscreenTextureID, 0);
        
        
        if (mDepthTestingEnabled)
        {
            glGenRenderbuffers(1, &mOffscreenDepthRenderbuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, mOffscreenDepthRenderbuffer);
            glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, mRenderBufferSize.width, mRenderBufferSize.height);
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, mOffscreenDepthRenderbuffer);
        }
        
        if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
        {
            NSLog(@"failed to make framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
            sResult = NO;
        }
    }];

    return sResult;
}


- (void)destroyOffscreenBuffer
{
    [PBContext performBlockOnMainThread:^{
        [[PBGLObjectManager sharedManager] deleteFramebuffer:mOffscreenFramebuffer];
        [[PBGLObjectManager sharedManager] deleteFramebuffer:mOffscreenColorRenderbuffer];
        [[PBGLObjectManager sharedManager] deleteFramebuffer:mOffscreenDepthRenderbuffer];
        
        mOffscreenFramebuffer       = 0;
        mOffscreenColorRenderbuffer = 0;
        mOffscreenDepthRenderbuffer = 0;
        
        PBTextureRelease(mOffscreenTextureID);
        mOffscreenTextureID         = 0;
    }];
}


- (void)bindOffscreenBuffer
{
    glBindRenderbuffer(GL_RENDERBUFFER, mOffscreenColorRenderbuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, mOffscreenFramebuffer);
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"failed to make framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
}


- (void)clearBackgroundColor:(PBColor *)aColor
{
    [self bindBuffer];
    glViewport(0, 0, mRenderBufferSize.width, mRenderBufferSize.height);
    glClearColor(aColor.r, aColor.g, aColor.b, aColor.a);
    
    if (mDepthTestingEnabled)
    {
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    }
    else
    {
        glClear(GL_COLOR_BUFFER_BIT);
    }
}


- (void)clearOffScreenBackgroundColor:(PBColor *)aColor
{
    [self bindOffscreenBuffer];
    glViewport(0, 0, mRenderBufferSize.width, mRenderBufferSize.height);
    glClearColor(aColor.r, aColor.g, aColor.b, aColor.a);
    
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


- (void)renderScene:(PBScene *)aScene
{
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    if (mDidProjectionChange)
    {
        [[aScene mesh] setProjection:mProjection];
        mDidProjectionChange = NO;
    }
    
    [aScene push];
    [[PBMeshRenderer sharedManager] render];
    glDisable(GL_BLEND);
}


- (void)renderForSelectionScene:(PBScene *)aScene
{
    [[PBMeshRenderer sharedManager] setSelectionMode:YES];
    [aScene pushSelectionWithRenderer:self];
    [[PBMeshRenderer sharedManager] render];
    [[PBMeshRenderer sharedManager] setSelectionMode:NO];
}


- (void)renderOffscreenToOnscreenWithCanvasSize:(CGSize)aCanvasSize
{
    [[PBMeshRenderer sharedManager] renderOffscreenToOnscreenWithCanvasSize:aCanvasSize offscreenTextureHandle:mOffscreenTextureID];
}


- (void)presentRenderBuffer
{
    [mContext presentRenderbuffer:GL_RENDERBUFFER];
}


- (void)beginSelectionMode
{
    [mNodesInSelectionMode autorelease];
    mNodesInSelectionMode = [[NSMutableArray alloc] init];
}


- (void)endSelectionMode
{
    [mNodesInSelectionMode release];
    mNodesInSelectionMode = nil;
}


- (PBNode *)nodeAtPoint:(CGPoint)aPoint
{
    if ((aPoint.x > mRenderBufferSize.width) || (aPoint.y > mRenderBufferSize.height))
    {
        return nil;
    }
    
    if (mNodesInSelectionMode)
    {
        __block NSUInteger sIndex;
        
        [PBContext performBlockOnMainThread:^{
            GLubyte sColor[4];
            
            glReadPixels(aPoint.x, mRenderBufferSize.height - aPoint.y, 1, 1, GL_RGBA, GL_UNSIGNED_BYTE, sColor);
            sIndex = (sColor[0] << 16) + (sColor[1] << 8) + sColor[2] - 1;
        }];
        
        if (sIndex < [mNodesInSelectionMode count])
        {
            return [mNodesInSelectionMode objectAtIndex:sIndex];
        }
    }
    
    return nil;
}


- (PBNode *)selectedNodeAtPoint:(CGPoint)aPoint
{
    PBNode *sNode = [self nodeAtPoint:aPoint];
    
    while (sNode && ([sNode isSelectable] == NO))
    {
        sNode = [sNode superNode];
    }
    
    return sNode;
}


- (void)addNodeForSelection:(PBNode *)aNode
{
    NSUInteger sCount = 1;
    GLubyte    sRed;
    GLubyte    sGreen;
    GLubyte    sBlue;
    
    [mNodesInSelectionMode addObject:aNode];
    
    sCount = [mNodesInSelectionMode count];
    sRed   = (sCount >> 16) & 0xff;
    sGreen = (sCount >> 8)  & 0xff;
    sBlue  = (sCount)       & 0xff;
    
    [aNode setSelectionColorWithRed:(sRed   & 0xff) / 255.0
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
    [self destroyOffscreenBuffer];
    
    [mNodesInSelectionMode release];
    
    [super dealloc];
}


@end
