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


const  GLushort gIndices[6]            = { 0, 1, 2, 2, 3, 0 };
static GLuint  gBoundaryTextureHandle = 0;
static GLfloat gBoundaryLineWidth     = 1.0;


@implementation PBMesh
{
    PBMatrix     mProjection;
    PBProgram   *mProgram;
    PBTexture   *mTexture;
    
    NSString    *mMeshKey;
    PBMeshArray *mMeshArray;

    BOOL         mBoundary;
    GLuint       mBoundaryTextureHandle;
}


@synthesize projection = mProjection;
@synthesize program    = mProgram;
@synthesize meshKey    = mMeshKey;
@synthesize meshArray  = mMeshArray;
@synthesize boundary   = mBoundary;


#pragma mark -


// for drawing boundary mesh
void generatorBoundaryTexture()
{
    GLubyte sPixels[4 * 3] =
    {
        200, 50, 50,
        0,   0,   0,
        0,   0,   0,
        0,   0,   0
    };

    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glGenTextures(1, &gBoundaryTextureHandle);
    glBindTexture(GL_TEXTURE_2D, gBoundaryTextureHandle);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 1, 1, 0, GL_RGB, GL_UNSIGNED_BYTE, sPixels);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
}


+ (void)initialize
{
    [PBContext performBlockOnMainThread:^{
        gBoundaryLineWidth = [[UIScreen mainScreen] scale];
        generatorBoundaryTexture();
    }];
}


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

        [PBContext performBlockOnMainThread:^{
            [self setProgram:[[PBProgramManager sharedManager] program]];
        }];
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


- (void)setProgram:(PBProgram *)aProgram
{
    [mProgram autorelease];
    mProgram = [aProgram retain];
    
    [mProgram use];
}


#pragma mark - for render


- (void)applyProgram:(PBTransform *)aTransform
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


- (void)applyTransform:(PBTransform *)aTransform
{
    PBMatrix sMatrix = PBMatrixIdentity;
    sMatrix = [PBMatrixOperator translateMatrix:sMatrix translate:[aTransform translate]];
    sMatrix = [PBMatrixOperator scaleMatrix:sMatrix scale:[aTransform scale]];
    sMatrix = [PBMatrixOperator rotateMatrix:sMatrix angle:[aTransform angle]];
    sMatrix = [PBMatrixOperator multiplyMatrixA:sMatrix matrixB:mProjection];
    
    glUniformMatrix4fv([mProgram location].projectionLoc, 1, 0, &sMatrix.m[0][0]);

    [self setProjection:sMatrix];
}


- (void)applyColor:(PBColor *)aColor
{
    if (aColor)
    {
        GLfloat sColors[4] = { [aColor red], [aColor green], [aColor blue], [aColor alpha] };
        glVertexAttrib4fv([mProgram location].colorLoc, sColors);
    }
    else
    {
        GLfloat sColors[4] = {1.0, 1.0, 1.0, 1.0};
        glVertexAttrib4fv([mProgram location].colorLoc, sColors);
    }
}


#pragma mark - PBDrawable


- (void)boundaryDraw
{
    if (gBoundaryTextureHandle)
    {
        glBindTexture(GL_TEXTURE_2D, gBoundaryTextureHandle);
        
        if ([mMeshArray validate])
        {
            glLineWidth(gBoundaryLineWidth);
            glBindTexture(GL_TEXTURE_2D, gBoundaryTextureHandle);
            glBindVertexArrayOES([mMeshArray vertexArray]);
            glDrawElements(GL_LINE_LOOP, sizeof(gIndices) / sizeof(gIndices[0]), GL_UNSIGNED_BYTE, 0);
            glBindVertexArrayOES(0);
        }
    }
}


- (void)draw
{
    if (mBoundary)
    {
        [self boundaryDraw];
    }

    if (mTexture)
    {
        NSLog(@"texture id = %d", [mTexture handle]);
        glBindTexture(GL_TEXTURE_2D, [mTexture handle]);
    }
    
    GLuint sVertexArray = [mMeshArray vertexArray];
    if (sVertexArray)
    {
        glBindVertexArrayOES(sVertexArray);
        glDrawElements(GL_TRIANGLE_STRIP, sizeof(gIndices) / sizeof(gIndices[0]), GL_UNSIGNED_SHORT, 0);
        glBindVertexArrayOES(0);
    }
}


@end
