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


#define kMeshVertexCount        4
#define kMeshVertexSize         12
#define kMeshCoordinateSize     8
#define kMeshPositionAttrSize   3
#define kMeshTexCoordAttrSize   2


typedef enum
{
    kPBMeshRenderOptionUsingMeshQueue = 0,
    kPBMeshRenderOptionUsingCallback,
} PBMeshRenderOption;


extern const GLfloat  gTexCoordinates[];
extern const GLfloat  gFlipTexCoordinates[];
extern const GLushort gIndices[6];


@class PBProgram;
@class PBTexture;
@class PBColor;
@class PBTransform;


typedef void (^PBMeshRenderCallback)();


@interface PBMesh : NSObject
{
    GLfloat mVertices[kMeshVertexSize];
    GLfloat mCoordinates[kMeshCoordinateSize];
}

- (void)updateMeshData;


- (GLfloat *)vertices;
- (GLfloat *)coordinates;


- (void)setZPoint:(GLfloat)aZPoint;
- (GLfloat)zPoint;


- (void)setMeshRenderOption:(PBMeshRenderOption)aOption;
- (PBMeshRenderOption)meshRenderOption;
- (void)setMeshRenderCallback:(PBMeshRenderCallback)aCallback;
- (void)performMeshRenderCallback;
- (void)drainMeshRenderCallback;


- (void)setProgram:(PBProgram *)aProgram;
- (PBProgram *)program;


- (void)setProjection:(PBMatrix)aProjection;
- (PBMatrix)projection;
- (PBMatrix)superProjection;


- (void)setTexture:(PBTexture *)aTexture;
- (PBTexture *)texture;
- (CGSize)size;


- (void)setTransform:(PBTransform *)aTransform;
- (PBTransform *)transform;


- (void)setColor:(PBColor *)aColor;
- (PBColor *)color;


- (void)applyTransform;
- (void)applySuperTransform;
- (void)applyColor;


- (void)pushMesh;


@end
