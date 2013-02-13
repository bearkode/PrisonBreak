/*
 *  PBRenderable.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 4..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


typedef enum
{
    kPBRenderingDisplayMode = 1,
    kPBRenderingSelectMode  = 2,
} PBRenderingMode;


typedef struct {
    GLenum sfactor;
    GLenum dfactor;
} PBBlendMode;


@class PBTexture;
@class PBTransform;



@interface PBRenderable : NSObject


@property (nonatomic, assign)                GLuint       programObject;
@property (nonatomic, assign)                PBBlendMode  blendMode;
@property (nonatomic, retain)                PBTransform *transform;
@property (nonatomic, retain)                NSString    *name;
@property (nonatomic, getter = isSelectable) BOOL         selectable;
@property (nonatomic, assign)                BOOL         hidden;


#pragma mark -


+ (id)textureRenderableWithTexture:(PBTexture *)aTexture;


#pragma mark -


- (id)initWithTexture:(PBTexture *)aTexture;


#pragma mark -


- (void)setTexture:(PBTexture *)aTexture;
- (PBTexture *)texture;


#pragma mark -


- (void)setPosition:(CGPoint)aPosition textureSize:(CGSize)aTextureSize;
- (void)setPosition:(CGPoint)aPosition;
- (CGPoint)position;


#pragma mark -


- (void)setSuperrenderable:(PBRenderable *)aRenderable;
- (PBRenderable *)superrenderable;

- (NSArray *)subrenderables;
- (void)setSubrenderables:(NSArray *)aSubrenderables;

- (void)addSubrenderable:(PBRenderable *)aRenderable;
- (void)removeSubrenderable:(PBRenderable *)aRenderable;

- (void)removeFromSuperrenderable;


#pragma mark -


- (void)performRenderingWithProjection:(PBMatrix4)aProjection;
- (void)performSelectionWithProjection:(PBMatrix4)aProjection renderer:(PBRenderer *)aRenderer;


#pragma mark -

- (void)setSelectionColorWithRed:(CGFloat)aRed green:(CGFloat)aGreen blue:(CGFloat)aBlue;


@end
