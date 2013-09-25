/*
 *  PBRenderer.m
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 25..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <OpenGLES/ES2/gl.h>
#import "PBRenderer.h"
#import "PBContext.h"
#import "PBNode.h"
#import "PBScene.h"
#import "PBColor.h"
#import "PBException.h"
#import "PBGLObjectManager.h"
#import "PBMeshRenderer.h"


@implementation PBRenderer
{
    CGSize          mRenderBufferSize;
    
    GLuint          mFramebuffer;
    GLuint          mColorRenderbuffer;
    GLuint          mDepthRenderbuffer;
    
    BOOL            mDepthTestingEnabled;
    
    EAGLContext    *mContext;
    NSMutableArray *mNodesInSelectionMode;
}


@synthesize renderBufferSize    = mRenderBufferSize;
@synthesize depthTestingEnabled = mDepthTestingEnabled;


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
        glGenFramebuffers(1, &mFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, mFramebuffer);
        
        glGenRenderbuffers(1, &mColorRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, mColorRenderbuffer);
        [mContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)aLayer];
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, mColorRenderbuffer);
        
        GLint sDisplayWidth;
        GLint sDisplayHeight;
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &sDisplayWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &sDisplayHeight);
        mRenderBufferSize = CGSizeMake(sDisplayWidth, sDisplayHeight);
        
        if (mDepthTestingEnabled)
        {
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


- (void)clearBackgroundColor:(PBColor *)aColor withScene:(PBScene *)aScene
{
    if (aScene)
    {
        [aScene bindBuffer];
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


#pragma mark -


- (void)renderScene:(PBScene *)aScene
{
    [aScene bindBuffer];
    
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
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


- (void)renderScreenForScene:(PBScene *)aScene
{
    [self bindBuffer];
    [[PBMeshRenderer sharedManager] renderToTexture:[aScene textureHandle] withCanvasSize:mRenderBufferSize];
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
    
    [mNodesInSelectionMode release];
    
    [super dealloc];
}


@end
