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


#pragma mark -


typedef struct {
    GLfloat vertex[2];
    GLfloat coordinates[2];
} PBMeshData;


static const GLfloat gTexCoordinates[] =
{
    0.0f, 0.0f,
    0.0f, 1.0f,
    1.0f, 1.0f,
    1.0f, 0.0f,
};


//static const GLushort gIndices[] = { 0, 1, 2, 0, 2, 3 };
//static const GLushort gIndices[] = { 3, 0, 1, 3, 1, 2 };
static const GLubyte gIndices[] = { 0, 1, 2, 2, 3, 0 };


#pragma mark - PBMesh


@class PBProgram;
@class PBTexture;


@interface PBMesh : NSObject<PBDrawable>


@property (nonatomic, retain) PBProgram *program;
@property (nonatomic, retain) PBTexture *texture;


#pragma mark -


- (NSString *)meshKey;

- (void)makeMesh;
- (void)makeMeshWithTexture:(PBTexture *)aTexture program:(PBProgram *)aProgram;


#pragma mark -


- (void)setCoordinates:(GLfloat *)aCoordinates;
- (GLfloat *)coordinates;

- (void)setVertices:(GLfloat *)aVertices;
- (void)setVerticesWithSize:(CGSize)aSize;
- (GLfloat *)vertices;


#pragma mark -


- (PBMeshData *)mesh;


@end
