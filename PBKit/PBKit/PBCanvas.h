/*
 *  PBCanvas.h
 *  PBKit
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>


typedef enum
{
    kPBDisplayFrameRateHigh = 1,    /*  1/60 sec  */
    kPBDisplayFrameRateMid  = 2,    /*  1/30 sec  */
    kPBDisplayFrameRateLow  = 3,    /*  1/15 sec  */
} PBDisplayFrameRate;


typedef enum
{
    kPBSceneAnimationTransitionNone           = 0,
    // ...
} PBSceneTransition;


@class PBScene;
@class PBNode;
@class PBColor;
@class PBRenderer;
@class PBCamera;


@interface PBCanvas : UIView <UIGestureRecognizerDelegate>


#pragma mark -


@property (nonatomic, retain)   PBColor     *backgroundColor;
@property (nonatomic, readonly) PBRenderer  *renderer;
@property (nonatomic, readonly) PBCamera    *camera;


#pragma mark -


- (void)setDisplayFrameRate:(PBDisplayFrameRate)aFrameRate;
- (PBDisplayFrameRate)displayFrameRate;


- (void)startDisplayLoop;
- (void)stopDisplayLoop;


#pragma mark -


- (void)presentScene:(PBScene *)aScene;
- (void)presentScene:(PBScene *)aScene withTransition:(PBSceneTransition)aTransition;


#pragma mark -


- (void)updateTimeInterval:(CADisplayLink *)aDisplayLink;
- (CFTimeInterval)timeInterval;
- (void)updateFPS;
- (NSInteger)fps;


#pragma mark -


- (void)beginSelectionMode;
- (void)endSelectionMode;
- (PBNode *)selectedNodeAtPoint:(CGPoint)aPoint;


#pragma mark -


- (CGPoint)canvasPointFromViewPoint:(CGPoint)aPoint;
- (CGPoint)viewPointFromCanvasPoint:(CGPoint)aPoint;


@end