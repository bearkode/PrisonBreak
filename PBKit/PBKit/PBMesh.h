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


#define kMeshVertexCount 4
#define kMeshOffsetSize  8


typedef struct {
    GLfloat vertex[2];
    GLfloat coordinates[2];
} PBMeshData;


extern const GLushort gIndices[6];


@class PBProgram;
@class PBTexture;
@class PBColor;
@class PBTransform;
@class PBMeshArray;


@interface PBMesh : NSObject
{
    GLfloat    mCoordinates[8];
    GLfloat    mVertices[8];
    PBMeshData mMeshData[kMeshVertexCount];
}

@property (nonatomic, retain) PBProgram   *program;
@property (nonatomic, retain) NSString    *meshKey;
@property (nonatomic, retain) PBMeshArray *meshArray;


- (PBMeshData *)meshData;
- (void)updateMeshData;


- (GLfloat *)vertices;
- (GLfloat *)coordinates;


- (void)setProjection:(PBMatrix)aProjection;
- (PBMatrix)projection;


- (void)setTexture:(PBTexture *)aTexture;
- (PBTexture *)texture;
- (void)setTransform:(PBTransform *)aTransform;
- (PBTransform *)tranform;
- (void)setColor:(PBColor *)aColor;
- (void)setProgramForTransform:(PBTransform *)aTransform;


- (void)setUsingMeshQueue:(BOOL)aUsing;
- (BOOL)isUsingMeshQueue;


- (void)applyTransform;
- (void)applySuperTransform;
- (void)applyColor;


- (void)pushMesh;


@end
