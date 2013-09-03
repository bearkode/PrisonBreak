/*
 *  PBMesh.h
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 27..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <OpenGLES/ES2/gl.h>
#import "PBMatrix.h"
#import "PBVertices.h"


typedef enum
{
    kPBMeshRenderOptionDefault = 0,
    kPBMeshRenderOptionImmediately,
} PBMeshRenderOption;


typedef enum
{
    kPBMeshCoordinateNormal = 0,
    kPBMeshCoordinateFlipHorizontal,
    kPBMeshCoordinateFlipVertical
} PBMeshCoordinateMode;


@class PBProgram;
@class PBTexture;
@class PBColor;
@class PBTransform;


@interface PBMesh : NSObject
{
    GLfloat mVertices[kMeshVertexSize];
    GLfloat mCoordinates[kMeshCoordinateSize];
}


- (void)updateMeshData;


- (GLfloat *)vertices;
- (GLfloat *)coordinates;


- (void)setCoordinateMode:(PBMeshCoordinateMode)aMode;
- (PBMeshCoordinateMode)coordinateMode;


- (void)setPoint:(CGPoint)aPoint;
- (CGPoint)point;


- (void)setZPoint:(GLfloat)aZPoint;
- (GLfloat)zPoint;


- (void)setMeshRenderOption:(PBMeshRenderOption)aOption;
- (PBMeshRenderOption)meshRenderOption;


- (void)setProgram:(PBProgram *)aProgram;
- (PBProgram *)program;


- (void)setProjection:(PBMatrix)aProjection;
- (PBMatrix)projection;


- (void)setOriginPoint:(CGPoint)aOriginPoint;
- (CGPoint)originPoint;


- (void)setTexture:(PBTexture *)aTexture;
- (PBTexture *)texture;
- (void)setVertexSize:(CGSize)aSize;
- (CGSize)vertexSize;


- (void)setTransform:(PBTransform *)aTransform;
- (PBTransform *)transform;


- (void)setColor:(PBColor *)aColor;
- (PBColor *)color;


- (void)applyProjection;
- (void)applySuperProjection;
- (void)applyColor;


- (void)pushMesh;


@end
