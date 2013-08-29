/*
 *  PBMesh.m
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 27..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBMesh.h"
#import "PBMeshRenderer.h"
#import "PBProgram.h"
#import "PBProgramManager.h"
#import "PBTransform.h"
#import "PBColor.h"
#import "PBContext.h"
#import "PBTexture.h"


@implementation PBMesh
{
    PBMatrix             mProjection;
    PBMatrix             mSuperProjection;
    PBProgram           *mProgram;
    PBTexture           *mTexture;
    GLfloat              mZPoint;
    PBColor             *mColor;
    PBTransform         *mTransform;
    CGPoint              mAnchorPoint;
    PBMeshRenderOption   mMeshRenderOption;
    PBMeshCoordinateMode mCoordinateMode;
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
        mMeshRenderOption = kPBMeshRenderOptionDefault;
        mCoordinateMode   = kPBMeshCoordinateNormal;
        memcpy(mCoordinates, gCoordinateNormal, sizeof(GLfloat) * 8);
        
        mProjection = PBMatrixIdentity;
        
        [PBContext performBlockOnMainThread:^{
            [self setProgram:[[PBProgramManager sharedManager] program]];
        }];
    }
    
    return self;
}


- (void)dealloc
{
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


- (void)setCoordinateMode:(PBMeshCoordinateMode)aMode
{
    mCoordinateMode = aMode;
    switch (mCoordinateMode)
    {
        case kPBMeshCoordinateNormal:
            memcpy(mCoordinates, gCoordinateNormal, sizeof(GLfloat) * 8);
            break;
        case kPBMeshCoordinateFlipHorizontal:
            memcpy(mCoordinates, gCoordinateFliphorizontal, sizeof(GLfloat) * 8);
            break;
        case kPBMeshCoordinateFlipVertical:
            memcpy(mCoordinates, gCoordinateFlipVertical, sizeof(GLfloat) * 8);
            break;
        default:
            break;
    }
}


- (PBMeshCoordinateMode)coordinateMode
{
    return mCoordinateMode;
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


- (PBMatrix)superProjection
{
    return mSuperProjection;
}


- (void)setAnchorPoint:(CGPoint)aAnchorPoint
{
    mAnchorPoint = aAnchorPoint;
}


- (CGPoint)anchorPoint
{
    return mAnchorPoint;
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
        PBMatrix sMatrix = mProjection;
        sMatrix = PBTranslateMatrix(sMatrix, [aTransform translate]);
        sMatrix = PBScaleMatrix(sMatrix, [mTransform scale]);
        sMatrix = PBRotateMatrix(sMatrix, [mTransform angle]);
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


#pragma mark -


- (void)applyProjection
{
    glUniformMatrix4fv([mProgram location].projectionLoc, 1, 0, &mProjection.m[0]);
}


- (void)applySuperProjection
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
    if (mTexture || [mProgram mode] == kPBProgramModeManual)
    {
        [[PBMeshRenderer sharedManager] addMesh:self];
    }
}


@end
