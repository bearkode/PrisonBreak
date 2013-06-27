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


@class PBRenderer;
@class PBScene;


typedef void (*PBNodePushFuncPtr)(id, SEL);


@interface PBNode : NSObject
{
    SEL               mPushSelector;
    PBNodePushFuncPtr mPushFunc;
}


@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) BOOL      hidden;


#pragma mark -


- (void)setMeshRenderOption:(PBMeshRenderOption)aRenderOption;
- (void)setMeshRenderCallback:(PBMeshRenderCallback)aCallback;
- (void)drainMeshRenderCallback;


#pragma mark -


- (void)setPoint:(CGPoint)aPoint;
- (CGPoint)point;

- (void)setZPoint:(GLfloat)aPointZ;
- (GLfloat)zPoint;


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


- (void)setScale:(CGFloat)aScale;
- (CGFloat)scale;
- (void)setAngle:(PBVertex3)aAngle;
- (PBVertex3)angle;
- (void)setColor:(PBColor *)aColor;
- (PBColor *)color;
- (void)setAlpha:(CGFloat)aAlpha;
- (CGFloat)alpha;

- (void)setGrayscale:(BOOL)aGrayscale;
- (BOOL)grayscale;
- (void)setSepia:(BOOL)aSepia;
- (BOOL)sepia;
- (void)setBlur:(BOOL)aBlur;
- (BOOL)blur;
- (void)setLuminance:(BOOL)aLuminance;
- (BOOL)luminance;


@end
