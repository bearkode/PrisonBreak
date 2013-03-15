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


@interface PBLayer : NSObject


@property (nonatomic, assign)                PBProgram   *program;
@property (nonatomic, assign)                PBBlendMode  blendMode;
@property (nonatomic, retain)                PBTransform *transform;
@property (nonatomic, readonly)              PBMesh      *mesh;
@property (nonatomic, retain)                NSString    *name;
@property (nonatomic, getter = isSelectable) BOOL         selectable;
@property (nonatomic, assign)                BOOL         hidden;


#pragma mark -


- (void)setTexture:(PBTexture *)aTexture;
- (PBTexture *)texture;


#pragma mark -


- (void)setPoint:(CGPoint)aPoint textureSize:(CGSize)aTextureSize;
- (void)setPoint:(CGPoint)aPoint;
- (CGPoint)point;


#pragma mark -


- (void)setSuperlayer:(PBLayer *)aLayer;
- (PBLayer *)superlayer;

- (NSArray *)sublayers;
- (void)setSublayers:(NSArray *)aSublayers;

- (void)addSublayer:(PBLayer *)aLayer;
- (void)removeSublayer:(PBLayer *)aLayer;

- (void)removeFromSuperlayer;


#pragma mark -


- (void)sortSublayersUsingSelector:(SEL)aSelector;


#pragma mark -


- (void)render;
- (void)renderSelectionWithRenderer:(PBRenderer *)aRenderer;


#pragma mark -


- (void)setSelectionColorWithRed:(CGFloat)aRed green:(CGFloat)aGreen blue:(CGFloat)aBlue;


@end
