/*
 *  PBRenderable.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 4..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


@class PBTexture;
@class PBTransform;


@interface PBRenderable : NSObject

@property (nonatomic, assign) GLuint       programObject;
@property (nonatomic, assign) GLenum       blendModeSFactor;
@property (nonatomic, assign) GLenum       blendModeDFactor;
@property (nonatomic, retain) PBTransform *transform;

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

- (NSArray *)subrenderables;
- (void)setSubrenderables:(NSArray *)aSubrenderables;
- (void)addSubrenderable:(PBRenderable *)aRenderable;

#pragma mark -

- (void)performRenderingWithProjection:(PBMatrix4)aProjection;

@end
