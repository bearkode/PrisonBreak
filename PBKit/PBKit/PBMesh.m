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
#import "PBKit.h"


static const GLfloat gTexCoordinates[] =
{
    0.0f, 0.0f,
    0.0f, 1.0f,
    1.0f, 1.0f,
    1.0f, 0.0f,
};


//static const GLushort gIndices[] = { 0, 1, 2, 0, 2, 3 };
//static const GLushort gIndices[] = { 3, 0, 1, 3, 1, 2 };
const GLubyte gIndices[6] = { 0, 1, 2, 2, 3, 0 };


@implementation PBMesh
{
    PBProgram   *mProgram;
    PBTexture   *mTexture;
    
    NSString    *mMeshKey;
    PBMeshArray *mMeshArray;
}


@synthesize program = mProgram;
@synthesize meshKey = mMeshKey;


#pragma mark - Private


- (void)setupVertices
{
    CGSize sSize = [mTexture size];
    
    mVertices[0] = -(sSize.width / 2);
    mVertices[1] = (sSize.height / 2);
    mVertices[2] = -(sSize.width / 2);
    mVertices[3] = -(sSize.height / 2);
    mVertices[4] = (sSize.width / 2);
    mVertices[5] = -(sSize.height / 2);
    mVertices[6] = (sSize.width / 2);
    mVertices[7] = (sSize.height / 2);
    
    mMeshData[0].vertex[0] = mVertices[0];
    mMeshData[0].vertex[1] = mVertices[1];
    mMeshData[1].vertex[0] = mVertices[2];
    mMeshData[1].vertex[1] = mVertices[3];
    mMeshData[2].vertex[0] = mVertices[4];
    mMeshData[2].vertex[1] = mVertices[5];
    mMeshData[3].vertex[0] = mVertices[6];
    mMeshData[3].vertex[1] = mVertices[7];
}


- (void)setupCoordinates
{
    mMeshData[0].coordinates[0] = mCoordinates[0];
    mMeshData[0].coordinates[1] = mCoordinates[1];
    mMeshData[1].coordinates[0] = mCoordinates[2];
    mMeshData[1].coordinates[1] = mCoordinates[3];
    mMeshData[2].coordinates[0] = mCoordinates[4];
    mMeshData[2].coordinates[1] = mCoordinates[5];
    mMeshData[3].coordinates[0] = mCoordinates[6];
    mMeshData[3].coordinates[1] = mCoordinates[7];
}


- (void)setupMeshKey
{
    char           sOutput[64 * 2];
    unsigned char *sIn  = (unsigned char *)mMeshData;
    char          *sOut = sOutput;
    const char    *sHex = "0123456789ABCDEF";

    for (NSInteger i = 0; i < 64; i++)
    {
        *sOut++ = sHex[(*sIn >> 4) & 0xF];
        *sOut++ = sHex[*sIn & 0xF];
        sIn++;
    }

    [mMeshKey autorelease];
    mMeshKey = [[NSString alloc] initWithBytes:sOutput length:(64 * 2) encoding:NSASCIIStringEncoding];
}


#pragma mark -


- (void)setupMeshArray
{
    NSAssert(mTexture, @"Must set PBTexture before makeMesh.");
    NSAssert(mProgram, @"Must set PBProgram before makeMesh.");

    [mMeshArray autorelease];
    mMeshArray = [[PBMeshArrayPool meshArrayWithMesh:self] retain];
    
    NSAssert(mMeshArray, @"Exception MeshArray is nil");
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
    [mProgram release];
    [mTexture release];

    [mMeshKey release];
    [mMeshArray release];
    
    [super dealloc];
}


#pragma mark -




- (PBMeshData *)meshData
{
    return mMeshData;
}


- (void)updateMeshData
{
    [self setupVertices];
    [self setupCoordinates];
    [self setupMeshKey];
    [self setupMeshArray];
}


- (void)setTexture:(PBTexture *)aTexture
{
    if (mTexture != aTexture)
    {
        [mTexture autorelease];
        mTexture = [aTexture retain];
        
        [self updateMeshData];
    }
}


#pragma mark - PBDrawable


- (void)draw
{
    if (mTexture)
    {
        glBindTexture(GL_TEXTURE_2D, [mTexture handle]);
    }
    
    if ([mMeshArray vertexArrayIndex])
    {
        glBindVertexArrayOES([mMeshArray vertexArrayIndex]);
        glDrawElements(GL_TRIANGLE_STRIP, sizeof(gIndices) / sizeof(gIndices[0]), GL_UNSIGNED_BYTE, 0);
        glBindVertexArrayOES(0);
    }
}


- (void)boundaryDraw
{
    
}


@end
