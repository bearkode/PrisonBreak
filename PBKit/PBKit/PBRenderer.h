/*
 *  PBRenderer.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */




#import <Foundation/Foundation.h>
#import "PBTransform.h"


@class PBColor;
@class PBLayer;


@interface PBRenderer : NSObject


@property (nonatomic, readonly) CGSize renderBufferSize;
@property (nonatomic, getter = isDepthTestingEnabled) BOOL depthTestingEnabled;
@property (nonatomic, readonly) GLuint offscreenTextureID;


#pragma mark -


- (void)setProjection:(PBMatrix)aProjection;


#pragma mark - prepare buffer

- (void)resetRenderBufferWithLayer:(CAEAGLLayer *)aLayer;


- (BOOL)createBufferWithLayer:(CAEAGLLayer *)aLayer;
- (void)destroyBuffer;
- (void)bindBuffer;


- (BOOL)createOffscreenBuffer;
- (void)destroyOffscreenBuffer;
- (void)bindOffscreenBuffer;


- (void)clearBackgroundColor:(PBColor *)aColor;
- (void)clearOffScreenBackgroundColor:(PBColor *)aColor;


#pragma mark - rendering


- (void)render:(PBLayer *)aLayer;
- (void)renderForSelection:(PBLayer *)aLayer;
- (void)renderOffscreenToOnscreenWithCanvasSize:(CGSize)aCanvasSize;
- (void)presentRenderBuffer;


#pragma mark - selectmode


- (void)beginSelectionMode;
- (void)endSelectionMode;
- (PBLayer *)layerAtPoint:(CGPoint)aPoint;
- (PBLayer *)selectedLayerAtPoint:(CGPoint)aPoint;
- (void)addLayerForSelection:(PBLayer *)aLayer;


@end
