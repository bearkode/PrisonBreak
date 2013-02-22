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
@class PBRenderable;


@interface PBRenderer : NSObject


@property (nonatomic, readonly) GLint     displayWidth;
@property (nonatomic, readonly) GLint     displayHeight;
@property (nonatomic, assign)   PBMatrix4 projection;


#pragma mark - prepare buffer

- (void)resetRenderBufferWithLayer:(CAEAGLLayer *)aLayer;
- (BOOL)createBufferWithLayer:(CAEAGLLayer *)aLayer;
- (void)destroyBuffer;
- (void)bindBuffer;
- (void)clearBackgroundColor:(PBColor *)aColor;


#pragma mark - bind shader location


- (void)bindShader;


#pragma mark - rendering


- (void)render:(PBRenderable *)aRenderable;
- (void)renderForSelection:(PBRenderable *)aRenderable;


#pragma mark - selectmode


- (void)beginSelectionMode;
- (void)endSelectionMode;
- (PBRenderable *)renderableAtPoint:(CGPoint)aPoint;
- (PBRenderable *)selectedRenderableAtPoint:(CGPoint)aPoint;
- (void)addRenderableForSelection:(PBRenderable *)aRenderable;


@end
