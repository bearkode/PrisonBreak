/*
 *  PBNode.h
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


//typedef struct {
//    GLenum sfactor;
//    GLenum dfactor;
//} PBBlendMode;


@class PBTexture;
@class PBTransform;
@class PBRenderer;
@class PBMesh;
@class PBRootNode;


typedef void (*PBNodePushFuncPtr)(id, SEL);


@interface PBNode : NSObject
{
    SEL               mPushSelector;
    PBNodePushFuncPtr mPushFunc;
}


@property (nonatomic, assign)   PBProgram   *program;
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


- (void)setSuperNode:(PBNode *)aNode;
- (PBNode *)superNode;

- (NSArray *)subNodes;
- (void)setSubNodes:(NSArray *)aSubNodes;

- (void)addSubNode:(PBNode *)aNode;
- (void)addSubNodes:(NSArray *)aNodes;
- (void)removeSubNode:(PBNode *)aNode;
- (void)removeSubNodes:(NSArray *)aNodes;

- (void)removeFromSuperNode;

- (PBRootNode *)rootNode;


#pragma mark -


- (void)push;
- (void)pushSelectionWithRenderer:(PBRenderer *)aRenderer;


#pragma mark -

- (void)setSelectable:(BOOL)aSelectable;
- (BOOL)isSelectable;
- (void)setSelectionColorWithRed:(CGFloat)aRed green:(CGFloat)aGreen blue:(CGFloat)aBlue;


@end
