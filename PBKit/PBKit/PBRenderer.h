/*
 *  PBRenderer.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */




#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "PBTransform.h"


@class PBColor;
@class PBNode;
@class PBScene;


@interface PBRenderer : NSObject


@property (nonatomic, readonly) CGSize renderBufferSize;
@property (nonatomic, assign)   BOOL   depthTestingEnabled;


#pragma mark - prepare buffer


- (void)resetRenderBufferWithLayer:(CAEAGLLayer *)aLayer;


- (BOOL)createBufferWithLayer:(CAEAGLLayer *)aLayer;
- (void)destroyBuffer;
- (void)bindBuffer;


- (void)clearBackgroundColor:(PBColor *)aColor withScene:(PBScene *)aScene;


#pragma mark - rendering


- (void)renderScene:(PBScene *)aScene;
- (void)renderForSelectionScene:(PBScene *)aScene;
- (void)renderScreenForScene:(PBScene *)aScene;
- (void)presentRenderBuffer;


#pragma mark - selectmode


- (void)beginSelectionMode;
- (void)endSelectionMode;
- (PBNode *)nodeAtPoint:(CGPoint)aPoint;
- (PBNode *)selectedNodeAtPoint:(CGPoint)aPoint;
- (void)addNodeForSelection:(PBNode *)aNode;


@end
