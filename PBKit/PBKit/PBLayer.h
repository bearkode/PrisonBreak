/*
 *  PBLayer.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 4..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "PBTransform.h"
#import "PBProgramManager.h"
#import "PBMesh.h"


typedef enum
{
    kPBRenderDisplayMode = 1,
    kPBRenderSelectMode  = 2,
} PBRenderMode;


typedef struct {
    GLenum sfactor;
    GLenum dfactor;
} PBBlendMode;


@class PBTexture;
@class PBTransform;
@class PBRenderer;
@class PBMesh;
@class PBRootLayer;


@interface PBLayer : NSObject


@property (nonatomic, assign)   PBProgram   *program;
@property (nonatomic, assign)   PBBlendMode  blendMode;
@property (nonatomic, retain)   PBTransform *transform;
@property (nonatomic, readonly) PBMesh      *mesh;
@property (nonatomic, retain)   NSString    *name;
@property (nonatomic, assign)   BOOL         hidden;


#pragma mark -


- (void)setTexture:(PBTexture *)aTexture;
- (PBTexture *)texture;


- (void)setMeshRenderOption:(PBMeshRenderOption)aRenderOption;


#pragma mark -


- (void)setPoint:(CGPoint)aPoint;
- (CGPoint)point;


- (void)setPointZ:(GLfloat)aPointZ;
- (GLfloat)zPoint;


#pragma mark -


- (void)setSuperlayer:(PBLayer *)aLayer;
- (PBLayer *)superlayer;

- (NSArray *)sublayers;
- (void)setSublayers:(NSArray *)aSublayers;

- (void)addSublayer:(PBLayer *)aLayer;
- (void)addSublayers:(NSArray *)aLayers;
- (void)removeSublayer:(PBLayer *)aLayer;
- (void)removeSublayers:(NSArray *)aLayers;

- (void)removeFromSuperlayer;

- (PBRootLayer *)rootLayer;


#pragma mark -


//- (void)sortSublayersUsingSelector:(SEL)aSelector;


#pragma mark -


- (void)push;
- (void)pushSelectionWithRenderer:(PBRenderer *)aRenderer;


#pragma mark -

- (void)setSelectable:(BOOL)aSelectable;
- (BOOL)isSelectable;
- (void)setSelectionColorWithRed:(CGFloat)aRed green:(CGFloat)aGreen blue:(CGFloat)aBlue;


@end
