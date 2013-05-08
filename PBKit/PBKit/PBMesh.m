/*
 *  PBMesh.m
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 27..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBMesh.h"
#import "PBKit.h"
#import "PBMeshArray.h"
#import "PBMeshArrayPool.h"
#import "PBMeshRenderer.h"


static const GLfloat gTexCoordinates[] =
{
    0.0f, 0.0f,
    0.0f, 1.0f,
    1.0f, 1.0f,
    1.0f, 0.0f,
};


const  GLushort gIndices[6] = { 0, 1, 2, 2, 3, 0 };


@implementation PBMesh
{
    PBMatrix            mProjection;
    PBMatrix            mSuperProjection;
    PBProgram           *mProgram;
    PBTexture           *mTexture;
    GLfloat              mPointZ;
    PBColor             *mColor;
    PBTransform         *mTransform;
    PBMeshRenderOption   mMeshRenderOption;
    PBMeshRenderCallback mMeshRenderCallback;

    BOOL                 mUseMeshArray;
    NSString            *mMeshKey;
    PBMeshArray         *mMeshArray;
}


@synthesize program            = mProgram;
@synthesize useMeshArray       = mUseMeshArray;
@synthesize meshKey            = mMeshKey;
@synthesize meshArray          = mMeshArray;
@synthesize meshRenderCallback = mMeshRenderCallback;


#pragma mark - Private


- (void)setupVertices
{
    CGSize sSize = [mTexture size];
    
    mVertices[0]  = -(sSize.width / 2);
    mVertices[1]  = (sSize.height / 2);
    mVertices[2]  = mPointZ;
    mVertices[3]  = -(sSize.width / 2);
    mVertices[4]  = -(sSize.height / 2);
    mVertices[5]  = mPointZ;
    mVertices[6]  = (sSize.width / 2);
    mVertices[7]  = -(sSize.height / 2);
    mVertices[8]  = mPointZ;
    mVertices[9]  = (sSize.width / 2);
    mVertices[10] = (sSize.height / 2);
    mVertices[11] = mPointZ;
    
    mMeshData[0].vertex[0] = mVertices[0];
    mMeshData[0].vertex[1] = mVertices[1];
    mMeshData[0].vertex[2] = mVertices[2];
    mMeshData[1].vertex[0] = mVertices[3];
    mMeshData[1].vertex[1] = mVertices[4];
    mMeshData[1].vertex[2] = mVertices[5];
    mMeshData[2].vertex[0] = mVertices[6];
    mMeshData[2].vertex[1] = mVertices[7];
    mMeshData[2].vertex[2] = mVertices[8];
    mMeshData[3].vertex[0] = mVertices[9];
    mMeshData[3].vertex[1] = mVertices[10];
    mMeshData[3].vertex[2] = mVertices[11];
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
    unsigned int   sCount = (3 + 2) * sizeof(GLfloat) * 4;
    char           sOutput[sCount * 2];
    unsigned char *sIn  = (unsigned char *)mMeshData;
    char          *sOut = sOutput;
    const char    *sHex = "0123456789ABCDEF";
    
    for (NSInteger i = 0; i < sCount; i++)
    {
        *sOut++ = sHex[(*sIn >> 4) & 0xF];
        *sOut++ = sHex[*sIn & 0xF];
        sIn++;
    }
    
    [mMeshKey autorelease];
    mMeshKey = [[NSString alloc] initWithBytes:sOutput length:(sCount * 2) encoding:NSASCIIStringEncoding];
}


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
        mMeshRenderOption = kPBMeshRenderOptionUsingMesh;
        mUseMeshArray     = YES;
        memcpy(mCoordinates, gTexCoordinates, sizeof(GLfloat) * 8);
        
        [PBContext performBlockOnMainThread:^{
            [self setProgram:[[PBProgramManager sharedManager] program]];
        }];
    }
    
    return self;
}


- (void)dealloc
{
    [mMeshRenderCallback release];
    [mTransform release];
    [mColor release];
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
    
    if (mUseMeshArray)
    {
        [self setupMeshKey];
        [self setupMeshArray];
    }
}


- (GLfloat *)vertices
{
    return mVertices;
}


- (GLfloat *)coordinates
{
    return mCoordinates;
}


- (void)setPointZ:(GLfloat)aPointZ
{
    mPointZ = aPointZ;
}


- (GLfloat)zPoint
{
    return mPointZ;
}


- (void)setProjection:(PBMatrix)aProjection
{
    mProjection      = aProjection;
    mSuperProjection = aProjection;
}


- (PBMatrix)projection
{
    return mProjection;
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


- (PBTexture *)texture
{
    return mTexture;
}


- (CGSize)size
{
    return [mTexture size];
}


- (void)setTransform:(PBTransform *)aTransform
{
    [mTransform autorelease];
    mTransform = [aTransform retain];
    
    PBMatrix sMatrix = PBMatrixIdentity;
    sMatrix = [PBMatrixOperator translateMatrix:sMatrix translate:[aTransform translate]];
    sMatrix = [PBMatrixOperator scaleMatrix:sMatrix scale:[aTransform scale]];
    sMatrix = [PBMatrixOperator rotateMatrix:sMatrix angle:[aTransform angle]];
    sMatrix = [PBMatrixOperator multiplyMatrixA:sMatrix matrixB:mProjection];
    mProjection = sMatrix;
}


- (PBTransform *)tranform
{
    return mTransform;
}


- (void)setColor:(PBColor *)aColor
{
    [mColor autorelease];
    mColor = [aColor retain];
}


- (void)setProgram:(PBProgram *)aProgram
{
    [mProgram autorelease];
    mProgram = [aProgram retain];
    
    [mProgram use];
}


- (void)setProgramForTransform:(PBTransform *)aTransform
{
    PBProgram *sProgram = [[PBProgramManager sharedManager] program];
    
    if ([aTransform grayscale])
    {
        sProgram = [[PBProgramManager sharedManager] grayscaleProgram];
    }
    else if ([aTransform sepia])
    {
        sProgram = [[PBProgramManager sharedManager] sepiaProgram];
    }
    else if ([aTransform blur])
    {
        sProgram = [[PBProgramManager sharedManager] blurProgram];
    }
    else if ([aTransform luminance])
    {
        sProgram = [[PBProgramManager sharedManager] luminanceProgram];
    }
    
    if ([sProgram programHandle] != [[PBProgramManager currentProgram] programHandle])
    {
        [self setProgram:sProgram];
    }
}


#pragma mark -


- (void)setMeshRenderOption:(PBMeshRenderOption)aOption
{
    mMeshRenderOption = aOption;
}


- (PBMeshRenderOption)meshRenderOption
{
    return mMeshRenderOption;
}


- (void)performMeshRenderCallback
{
    if (mMeshRenderCallback)
    {
        mMeshRenderCallback();
    }
}


- (void)drainMeshRenderCallback
{
    if (mMeshRenderCallback)
    {
        [mMeshRenderCallback autorelease];
        mMeshRenderCallback = nil;
    }
}


#pragma mark -


- (void)applyTransform
{
    glUniformMatrix4fv([mProgram location].projectionLoc, 1, 0, &mProjection.m[0][0]);
}


- (void)applySuperTransform
{
    glUniformMatrix4fv([mProgram location].projectionLoc, 1, 0, &mSuperProjection.m[0][0]);
}


- (void)applyColor
{
    if (mColor)
    {
        GLfloat sColors[4] = { [mColor red], [mColor green], [mColor blue], [mColor alpha] };
        glVertexAttrib4fv([mProgram location].colorLoc, sColors);
    }
    else
    {
        GLfloat sColors[4] = {1.0, 1.0, 1.0, 1.0};
        glVertexAttrib4fv([mProgram location].colorLoc, sColors);
    }
}


- (void)pushMesh
{
    [[PBMeshRenderer sharedManager] addMesh:self];
}


@end
