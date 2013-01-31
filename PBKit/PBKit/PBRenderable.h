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


@property (nonatomic, assign) GLuint          programObject;
@property (nonatomic, retain) PBTexture      *texture;
@property (nonatomic, assign) GLenum          blendModeSFactor;
@property (nonatomic, assign) GLenum          blendModeDFactor;
@property (nonatomic, copy)   NSMutableArray *subrenderables;
@property (nonatomic, retain) PBTransform    *transform;


#pragma mark -


- (id)initWithTexture:(PBTexture *)aTexture;


#pragma mark -


//- (void)setVertices:(PBVertice4)aVertices;
- (void)setPosition:(CGPoint)aPosition textureSize:(CGSize)aTextureSize;
- (void)setPosition:(CGPoint)aPosition;


#pragma mark -


- (void)performRenderingWithProjection:(PBMatrix4)aProjection;


@end
