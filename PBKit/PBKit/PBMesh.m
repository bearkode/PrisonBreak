/*
 *  PBMesh.m
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 27..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBMesh.h"
#import "PBProgram.h"
#import "PBTexture.h"
#import "PBMeshArray.h"
#import "PBMeshArrayPool.h"


#define kMeshVertexCount 4


@implementation PBMesh
{
    GLfloat      mCoordinates[8];
    GLfloat      mVertices[8];
    PBMeshData   mMesh[kMeshVertexCount];
    
    PBProgram   *mProgram;
    PBTexture   *mTexture;
    GLint        mVertexArrayIndex;
}


@synthesize program = mProgram;
@synthesize texture = mTexture;


#pragma mark - Private


- (void)arrangeVertices
{
    mMesh[0].vertex[0] = mVertices[0];
    mMesh[0].vertex[1] = mVertices[1];
    mMesh[1].vertex[0] = mVertices[2];
    mMesh[1].vertex[1] = mVertices[3];
    mMesh[2].vertex[0] = mVertices[4];
    mMesh[2].vertex[1] = mVertices[5];
    mMesh[3].vertex[0] = mVertices[6];
    mMesh[3].vertex[1] = mVertices[7];
}


- (void)arrangeCoordinates
{
    mMesh[0].coordinates[0] = mCoordinates[0];
    mMesh[0].coordinates[1] = mCoordinates[1];
    mMesh[1].coordinates[0] = mCoordinates[2];
    mMesh[1].coordinates[1] = mCoordinates[3];
    mMesh[2].coordinates[0] = mCoordinates[4];
    mMesh[2].coordinates[1] = mCoordinates[5];
    mMesh[3].coordinates[0] = mCoordinates[6];
    mMesh[3].coordinates[1] = mCoordinates[7];
}


#pragma mark -


- (void)setCoordinates:(GLfloat *)aCoordinates
{
    memcpy(mCoordinates, aCoordinates, sizeof(GLfloat) * 8);
}


- (GLfloat *)coordinates
{
    return mCoordinates;
}


- (void)setVertices:(GLfloat *)aVertices
{
    memcpy(mVertices, aVertices, sizeof(GLfloat) * 8);
}


- (void)setVerticesWithSize:(CGSize)aSize
{
    mVertices[0] = -(aSize.width / 2);
    mVertices[1] = (aSize.height / 2);
    mVertices[2] = -(aSize.width / 2);
    mVertices[3] = -(aSize.height / 2);
    mVertices[4] = (aSize.width / 2);
    mVertices[5] = -(aSize.height / 2);
    mVertices[6] = (aSize.width / 2);
    mVertices[7] = (aSize.height / 2);
}


- (GLfloat *)vertices
{
    return mVertices;
}


- (void)setTexture:(PBTexture *)aTexture
{
    [mTexture autorelease];
    mTexture = [aTexture retain];
    
    [self setVerticesWithSize:[mTexture size]];
}


#pragma mark -


- (PBMeshData *)mesh
{
    return mMesh;
}


#pragma mark -


- (void)makeMesh
{
    NSAssert(mTexture, @"Must set PBTexture before makeMesh.");
    NSAssert(mProgram, @"Must set PBProgram before makeMesh.");
    
    [self arrangeVertices];
    [self arrangeCoordinates];

    PBMeshArray *sMeshArray = [PBMeshArrayPool meshArrayForSize:[mTexture size] createIfNotExist:YES];
    if (sMeshArray)
    {
        if ([PBMeshArray isValidVertexArrayIndex:[sMeshArray vertexArrayIndex]])
        {
            mVertexArrayIndex = [sMeshArray vertexArrayIndex];
        }
        else
        {
            mVertexArrayIndex = [sMeshArray makeVertexArrayWithMesh:self program:mProgram];
        }
    }
    else
    {
        NSAssert(nil, @"Exception MeshArray is nil");
    }
}


- (void)makeMeshWithTexture:(PBTexture *)aTexture program:(PBProgram *)aProgram
{
    [self setTexture:aTexture];    
    [self setProgram:aProgram];

    [self makeMesh];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        memcpy(mCoordinates, gTexCoordinates, sizeof(GLfloat) * 8);
    }
    
    return self;
}


- (void)dealloc
{
    [mTexture release];
    [mProgram release];
    
    [super dealloc];
}


#pragma mark - PBDrawable


- (void)draw
{
    if (mTexture)
    {
        glBindTexture(GL_TEXTURE_2D, [mTexture handle]);
    }
    
    if (mVertexArrayIndex)
    {
        glBindVertexArrayOES(mVertexArrayIndex);
        glDrawElements(GL_TRIANGLE_STRIP, sizeof(gIndices)/sizeof(gIndices[0]), GL_UNSIGNED_BYTE, 0);
        glBindVertexArrayOES(0);        
    }
}


- (void)boundaryDraw
{
    
}


@end
