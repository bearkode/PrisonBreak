/*
 *  PBRenderable.h
 *  PBKit
 *
 *  Created by sshanks on 13. 1. 4..
 *  Copyright (c) 2013년 sshanks. All rights reserved.
 *
 */


@class PBTexture;
@class PBTransform;


@interface PBRenderable : NSObject
{
    CGFloat      mScale;
    PBVertice4   mVertices;
    GLuint       mProgramObject;

    PBTexture   *mTexture;
    PBTransform *mTransform;
    
    GLenum       mBlendModeSFactor;
    GLenum       mBlendModeDFactor;
}


@property (nonatomic, assign)   CGFloat      scale;
@property (nonatomic, assign)   GLuint       programObject;
@property (nonatomic, retain)   PBTexture   *texture;
@property (nonatomic, assign)   GLenum       blendModeSFactor;
@property (nonatomic, assign)   GLenum       blendModeDFactor;
@property (nonatomic, readonly) PBTransform *transform;


#pragma mark -


- (id)initWithTexture:(PBTexture *)aTexture;


#pragma mark -


- (void)setVertices:(PBVertice4)aVertices;
- (void)setPosition:(CGPoint)aPosition textureSize:(CGSize)aTextureSize;
- (void)setPosition:(CGPoint)aPosition;


#pragma mark -


- (void)rendering;


@end
