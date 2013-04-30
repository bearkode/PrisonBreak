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
    kPBMeshRenderOptionUsingMesh = 0,
    kPBMeshRenderOptionUsingMeshQueue,
    kPBMeshRenderOptionUsingCallback,
} PBMeshRenderOption;


typedef struct {
    GLfloat vertex[3];
    GLfloat coordinates[2];
} PBMeshData;


extern const GLushort gIndices[6];


@class PBProgram;
@class PBTexture;
@class PBColor;
@class PBTransform;
@class PBMeshArray;


typedef void (^PBMeshRenderCallback)();


@interface PBMesh : NSObject
{
    GLfloat    mVertices[kMeshVertexSize];
    GLfloat    mCoordinates[kMeshCoordinateSize];
    PBMeshData mMeshData[kMeshVertexCount];
}

@property (nonatomic, retain) PBProgram           *program;
@property (nonatomic, retain) NSString            *meshKey;
@property (nonatomic, retain) PBMeshArray         *meshArray;
@property (nonatomic, copy)   PBMeshRenderCallback meshRenderCallback;


- (PBMeshData *)meshData;
- (void)updateMeshData;


- (GLfloat *)vertices;
- (GLfloat *)coordinates;


- (void)setPointZ:(GLfloat)aPointZ;
- (GLfloat)zPoint;


- (void)setMeshRenderOption:(PBMeshRenderOption)aOption;
- (PBMeshRenderOption)meshRenderOption;
- (void)performMeshRenderCallback;
- (void)drainMeshRenderCallback;


- (void)setProjection:(PBMatrix)aProjection;
- (PBMatrix)projection;


- (void)setTexture:(PBTexture *)aTexture;
- (PBTexture *)texture;
- (CGSize)size;
- (void)setTransform:(PBTransform *)aTransform;
- (PBTransform *)tranform;
- (void)setColor:(PBColor *)aColor;
- (void)setProgramForTransform:(PBTransform *)aTransform;


- (void)applyTransform;
- (void)applySuperTransform;
- (void)applyColor;


- (void)pushMesh;


@end
