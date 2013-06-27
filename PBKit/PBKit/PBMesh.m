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
#import "PBMeshRenderer.h"


const GLfloat gTexCoordinates[] =
{
    0.0f, 0.0f,
    0.0f, 1.0f,
    1.0f, 1.0f,
    1.0f, 0.0f,
};


const GLfloat gFlipTexCoordinates[] =
{
    0.0f, 1.0f,
    0.0f, 0.0f,
    1.0f, 0.0f,
    1.0f, 1.0f,
};


const  GLushort gIndices[6] = { 0, 1, 2, 2, 3, 0 };


@implementation PBMesh
{
    PBMatrix            mProjection;
    PBMatrix            mSuperProjection;
    PBProgram           *mProgram;
    PBTexture           *mTexture;
    GLfloat              mZPoint;
    PBColor             *mColor;
    PBTransform         *mTransform;
    PBMeshRenderOption   mMeshRenderOption;
    PBMeshRenderCallback mMeshRenderCallback;
}


#pragma mark - Private


- (void)setupVertices
{
    CGSize sSize = [mTexture size];
    
    mVertices[0]  = -(sSize.width / 2);
    mVertices[1]  = (sSize.height / 2);
    mVertices[2]  = mZPoint;
    mVertices[3]  = -(sSize.width / 2);
    mVertices[4]  = -(sSize.height / 2);
    mVertices[5]  = mZPoint;
    mVertices[6]  = (sSize.width / 2);
    mVertices[7]  = -(sSize.height / 2);
    mVertices[8]  = mZPoint;
    mVertices[9]  = (sSize.width / 2);
    mVertices[10] = (sSize.height / 2);
    mVertices[11] = mZPoint;
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mMeshRenderOption = kPBMeshRenderOptionUsingMeshQueue;
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
    
    [super dealloc];
}


#pragma mark -


- (void)updateMeshData
{
    [self setupVertices];
}


- (GLfloat *)vertices
{
    return mVertices;
}


- (GLfloat *)coordinates
{
    return mCoordinates;
}


- (void)setZPoint:(GLfloat)aZPoint
{
    mZPoint = aZPoint;
}


- (GLfloat)zPoint
{
    return mZPoint;
}


- (void)setProgram:(PBProgram *)aProgram
{
    [mProgram autorelease];
    mProgram = [aProgram retain];
    
    [mProgram use];
}


- (PBProgram *)program
{
    return mProgram;
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


- (void)setProjection:(PBMatrix)aProjection
{
    [mTransform setDirty:YES];
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
    
    if ([mTransform checkDirty])
    {
        PBMatrix sMatrix = PBMatrixIdentity;
        sMatrix = PBTranslateMatrix(sMatrix, [aTransform translate]);
        sMatrix = PBScaleMatrix(sMatrix, [mTransform scale]);
        sMatrix = PBRotateMatrix(sMatrix, [mTransform angle]);
        sMatrix = PBMultiplyMatrix(sMatrix, mProjection);
        mProjection = sMatrix;
    }
}


- (PBTransform *)transform
{
    return mTransform;
}


- (void)setColor:(PBColor *)aColor
{
    [mColor autorelease];
    mColor = [aColor retain];
}


- (PBColor *)color
{
    return mColor;
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


- (void)setMeshRenderCallback:(PBMeshRenderCallback)aCallback
{
    [self drainMeshRenderCallback];
    mMeshRenderCallback = [aCallback copy];
}


- (void)drainMeshRenderCallback
{
    if (mMeshRenderCallback)
    {
        [mMeshRenderCallback autorelease];
        mMeshRenderCallback = nil;
    }
}


- (void)performMeshRenderCallback
{
    if (mMeshRenderCallback)
    {
        mMeshRenderCallback();
    }
}


#pragma mark -


- (void)applyTransform
{
    glUniformMatrix4fv([mProgram location].projectionLoc, 1, 0, &mProjection.m[0]);
}


- (void)applySuperTransform
{
    glUniformMatrix4fv([mProgram location].projectionLoc, 1, 0, &mSuperProjection.m[0]);
}


- (void)applyColor
{
    if (mColor)
    {
        GLfloat sColors[4] = { [mColor r], [mColor g], [mColor b], [mColor a] };
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
