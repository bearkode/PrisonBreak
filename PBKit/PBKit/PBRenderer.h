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
{
    GLint     mDisplayWidth;
    GLint     mDisplayHeight;
}


@property (nonatomic, readonly) GLint displayWidth;
@property (nonatomic, readonly) GLint displayHeight;


#pragma mark - prepare buffer


- (void)resetRenderBufferWithLayer:(CAEAGLLayer *)aLayer;
- (BOOL)createBufferWithLayer:(CAEAGLLayer *)aLayer;
- (void)destroyBuffer;
- (void)bindingBuffer;
- (void)clearBackgroundColor:(PBColor *)aColor;


#pragma mark - rendering


- (void)render:(PBRenderable *)aRenderable projection:(PBMatrix4)aProjection;
- (void)renderForSelection:(PBRenderable *)aRenderable projection:(PBMatrix4)aProjection;


#pragma mark - selectmode


- (void)beginSelectionMode;
- (void)endSelectionMode;
- (PBRenderable *)renderableAtPoint:(CGPoint)aPoint;
- (PBRenderable *)selectedRenderableAtPoint:(CGPoint)aPoint;
- (void)addRenderableForSelection:(PBRenderable *)aRenderable;


@end
