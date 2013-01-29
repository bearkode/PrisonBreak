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
    
    // blend mode
    GLenum       mBlendModeSFactor;
    GLenum       mBlendModeDFactor;
    
    
    // transform
    PBTransform *mTransform;
}


@property (nonatomic, assign) CGFloat      scale;
@property (nonatomic, assign) PBVertice4   vertices;
@property (nonatomic, assign) GLuint       programObject;
@property (nonatomic, retain) PBTexture   *texture;
@property (nonatomic, assign) GLenum       blendModeSFactor;
@property (nonatomic, assign) GLenum       blendModeDFactor;
@property (nonatomic, retain) PBTransform *transform;


#pragma mark -


- (void)setTextureVertices:(PBVertice4)aVertices program:(GLuint)aProgramObject;
- (void)setTextureViewPoint:(CGPoint)aViewPoint program:(GLuint)aProgramObject;


#pragma mark -


- (void)rendering;


@end
