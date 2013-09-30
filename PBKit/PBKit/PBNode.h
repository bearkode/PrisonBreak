/*
 *  PBNode.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 4..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import <UIKit/UIKit.h>
#import "PBMesh.h"


typedef enum
{
    kPBRenderDisplayMode = 1,
    kPBRenderSelectMode  = 2,
} PBRenderMode;


typedef enum
{
    kPBCoordinateNormal = 0,
    kPBCoordinateFlipHorizontal,
    kPBCoordinateFlipVertical
} PBCoordinateMode;


@class PBRenderer;
@class PBScene;


typedef void (*PBNodePushFuncPtr)(id, SEL);


@interface PBNode : NSObject


@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) BOOL      hidden;


#pragma mark -


- (void)setPoint:(CGPoint)aPoint;
- (CGPoint)point;

- (void)setZPoint:(GLfloat)aPointZ;
- (GLfloat)zPoint;

// if set to YES, projection of all the subnodes is fixed to the PBMatrixIdentity
// and When rendering a super_projection is not use.
- (void)setProjectionPackEnabled:(BOOL)aEnable;
- (void)setProjectionPackOrder:(NSInteger)aOrder;

- (BOOL)isEffectNode;
- (BOOL)isSpriteNode;


#pragma mark -


- (void)setSuperNode:(PBNode *)aNode;
- (PBNode *)superNode;

- (NSArray *)subNodes;
- (void)setSubNodes:(NSArray *)aSubNodes;

- (void)addSubNode:(PBNode *)aNode;
- (void)addSubNodes:(NSArray *)aNodes;
- (void)removeSubNode:(PBNode *)aNode;
- (void)removeSubNodes:(NSArray *)aNodes;

- (void)removeFromSuperNode;

- (PBScene *)scene;


#pragma mark -


- (void)push;
- (void)pushSelectionWithRenderer:(PBRenderer *)aRenderer;


#pragma mark -

- (void)setSelectable:(BOOL)aSelectable;
- (BOOL)isSelectable;
- (void)setSelectionColorWithRed:(CGFloat)aRed green:(CGFloat)aGreen blue:(CGFloat)aBlue;


#pragma mark -
#pragma mark Transform


- (void)setScale:(PBVertex3)aScale;
- (PBVertex3)scale;
- (void)setAngle:(PBVertex3)aAngle;
- (PBVertex3)angle;
- (void)setColor:(PBColor *)aColor;
- (PBColor *)color;
- (void)setAlpha:(CGFloat)aAlpha;
- (CGFloat)alpha;
- (void)setCoordinateMode:(PBCoordinateMode)aMode;
- (PBCoordinateMode)coordinateMode;


@end
