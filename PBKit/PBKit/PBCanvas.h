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


@class PBScene;
@class PBNode;
@class PBColor;
@class PBRenderer;
@class PBCamera;


@interface PBCanvas : UIView <UIGestureRecognizerDelegate>


#pragma mark -


@property (nonatomic, assign)   id          delegate;
@property (nonatomic, retain)   PBColor    *backgroundColor;
@property (nonatomic, readonly) PBScene    *scene;
@property (nonatomic, readonly) PBRenderer *renderer;
@property (nonatomic, readonly) PBCamera   *camera;


#pragma mark -


- (void)setDisplayFrameRate:(PBDisplayFrameRate)aFrameRate;
- (PBDisplayFrameRate)displayFrameRate;


- (void)startDisplayLoop;
- (void)stopDisplayLoop;


#pragma mark -


- (void)updateTimeInterval:(CADisplayLink *)aDisplayLink;
- (CFTimeInterval)timeInterval;
- (void)updateFPS;
- (NSInteger)fps;


#pragma mark -


- (void)registGestureEvent;

- (void)beginSelectionMode;
- (void)endSelectionMode;
- (PBNode *)selectedNodeAtPoint:(CGPoint)aPoint;


#pragma mark -


- (CGPoint)canvasPointFromViewPoint:(CGPoint)aPoint;
- (CGPoint)viewPointFromCanvasPoint:(CGPoint)aPoint;


@end


#pragma mark - PBDisplayDelegate;


@protocol PBCanvasDelegate <NSObject>


@optional
- (void)pbCanvasWillUpdate:(PBCanvas *)aView;
- (void)pbCanvasDidUpdate:(PBCanvas *)aView;


- (void)pbCanvas:(PBCanvas *)aCanvas didFinishRenderToOffscreenWithTextureHandle:(GLuint)aTextureHandle;


- (void)pbCanvas:(PBCanvas *)aCanvas didTapPoint:(CGPoint)aPoint;
- (void)pbCanvas:(PBCanvas *)aCanvas didLongTapPoint:(CGPoint)aPoint;


@end
