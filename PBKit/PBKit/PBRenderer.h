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


@property (nonatomic, readonly) GLint    displayWidth;
@property (nonatomic, readonly) GLint    displayHeight;
@property (nonatomic, getter = isDepthTestingEnabled) BOOL depthTestingEnabled;


#pragma mark -


- (void)setProjection:(PBMatrix)aProjection;


#pragma mark - prepare buffer

- (void)resetRenderBufferWithLayer:(CAEAGLLayer *)aLayer;
- (BOOL)createBufferWithLayer:(CAEAGLLayer *)aLayer;
- (void)destroyBuffer;
- (void)bindBuffer;
- (void)clearBackgroundColor:(PBColor *)aColor;


#pragma mark - rendering


- (void)render:(PBLayer *)aLayer;
- (void)renderForSelection:(PBLayer *)aLayer;
- (void)presentRenderBuffer;


#pragma mark - selectmode


- (void)beginSelectionMode;
- (void)endSelectionMode;
- (PBLayer *)layerAtPoint:(CGPoint)aPoint;
- (PBLayer *)selectedLayerAtPoint:(CGPoint)aPoint;
- (void)addLayerForSelection:(PBLayer *)aLayer;


@end
