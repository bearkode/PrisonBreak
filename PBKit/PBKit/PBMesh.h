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
    kPBMeshRenderOptionMerged,
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
    GLfloat mOriginVertices[kMeshVertexSize];
    GLfloat mCoordinates[kMeshCoordinateSize];
}


@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) GLfloat zPoint;
@property (nonatomic, assign) BOOL    projectionPackEnabled;
@property (nonatomic, assign) NSRange projectionPackOrder;


- (void)updateMeshData;


- (GLfloat *)vertices;
- (GLfloat *)originVertices;
- (GLfloat *)coordinates;

- (void)setCoordinateMode:(PBMeshCoordinateMode)aMode;
- (PBMeshCoordinateMode)coordinateMode;


- (void)setMeshRenderOption:(PBMeshRenderOption)aOption;
- (PBMeshRenderOption)meshRenderOption;


- (void)setProgram:(PBProgram *)aProgram;
- (PBProgram *)program;


- (void)setProjection:(PBMatrix)aProjection;
- (PBMatrix)projection;
- (PBMatrix)superProjection;
- (PBMatrix *)superProjectionPtr;
- (void)setSceneProjection:(PBMatrix)aSceneProjection;
- (PBMatrix)sceneProjection;


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
- (void)applySceneProjection;
- (void)applyColor;


- (void)pushMesh;


@end
