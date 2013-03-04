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
#import "PBDrawable.h"
#import "PBMatrix.h"


#define kMeshVertexCount 4


typedef struct {
    GLfloat vertex[2];
    GLfloat coordinates[2];
} PBMeshData;


extern const GLubyte gIndices[6];


@class PBProgram;
@class PBTexture;
@class PBColor;
@class PBTransform;


@interface PBMesh : NSObject <PBDrawable>
{
    GLfloat    mCoordinates[8];
    GLfloat    mVertices[8];
    PBMeshData mMeshData[kMeshVertexCount];
}

@property (nonatomic, assign)   PBMatrix   projection;
@property (nonatomic, retain)   PBProgram *program;
@property (nonatomic, readonly) NSString  *meshKey;
@property (nonatomic, assign)   BOOL       boundary;


- (PBMeshData *)meshData;
- (void)updateMeshData;

- (void)setTexture:(PBTexture *)aTexture;


- (void)applyProgram:(PBTransform *)aTransform;
- (void)applyTransform:(PBTransform *)aTransform;
- (void)applyColor:(PBColor *)aColor;


@end
