/*
 *  PBScene.h
 *  PBKit
 *
 *  Created by camelkode on 13. 4. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBNode.h"


typedef enum
{
    kPBSceneDelegatePhaseWillUpdate  = 1,
    kPBSceneDelegatePhaseDidUpdate   = 2,
    kPBSceneDelegatePhaseWillRender  = 3,
    kPBSceneDelegatePhaseDidRender   = 4,
} PBSceneDelegatePhase;


typedef enum
{
    kPBSceneTapDelegatePhaseTap     = 1,
    kPBSceneTapDelegatePhaseLongTap = 2,
} PBSceneTapDelegatePhase;


@class PBCanvas;


@interface PBScene : PBNode


@property (nonatomic, assign)   id           delegate;
@property (nonatomic, assign)   CGSize       sceneSize;
@property (nonatomic, readonly) GLuint       textureHandle;
@property (nonatomic, readonly, getter = isGeneratedBuffer) BOOL generatedBuffer;

- (id)initWithDelegate:(id)aDelegate;


- (void)bindBuffer;
- (void)resetRenderBuffer;


- (void)performSceneDelegatePhase:(PBSceneDelegatePhase)aPhase;
- (void)performSceneTapDelegatePhase:(PBSceneTapDelegatePhase)aPhase canvasPoint:(CGPoint)aCanvasPoint;


- (PBMatrix)projection;


@end


#pragma mark - PBSceneDelegate;


@protocol PBSceneDelegate <NSObject>

@optional

- (void)pbSceneWillUpdate:(PBScene *)aScene;
- (void)pbSceneDidUpdate:(PBScene *)aScene;
- (void)pbSceneWillRender:(PBScene *)aScene;
- (void)pbSceneDidRender:(PBScene *)aScene;

- (void)pbScene:(PBScene *)aScene didTapCanvasPoint:(CGPoint)aCanvasPoint;
- (void)pbScene:(PBScene *)aScene didLongTapCanvasPoint:(CGPoint)aCanvasPoint;

@end