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
    PBMatrix             mSceneProjection;
    PBProgram           *mProgram;
    PBTexture           *mTexture;
    CGPoint              mPoint;
    GLfloat              mZPoint;
    PBColor             *mColor;
    PBTransform         *mTransform;
    PBMeshRenderOption   mMeshRenderOption;
    PBMeshCoordinateMode mCoordinateMode;
    CGSize               mVertexSize;

    /* For projection pack */
    BOOL                 mProjectionPackEnabled;
    NSInteger            mProjectionPackOrder;
}


@synthesize point                 = mPoint;
@synthesize zPoint                = mZPoint;
@synthesize projectionPackEnabled = mProjectionPackEnabled;
@synthesize projectionPackOrder   = mProjectionPackOrder;


#pragma mark - Private


- (void)setupVertices
{
    CGSize sSize = mVertexSize;
    
    mSetupVertices[0]  = -(sSize.width / 2.0);
    mSetupVertices[1]  = (sSize.height / 2.0);
    mSetupVertices[2]  = mZPoint;
    mSetupVertices[3]  = -(sSize.width / 2.0);
    mSetupVertices[4]  = -(sSize.height / 2.0);
    mSetupVertices[5]  = mZPoint;
    mSetupVertices[6]  = (sSize.width / 2.0);
    mSetupVertices[7]  = -(sSize.height / 2.0);
    mSetupVertices[8]  = mZPoint;
    mSetupVertices[9]  = (sSize.width / 2.0);
    mSetupVertices[10] = (sSize.height / 2.0);
    mSetupVertices[11] = mZPoint;
}


- (void)arrangeMatrix
{
    PBTranslateMatrixPtr(&mProjection, [mTransform translate]);
    PBScaleMatrixPtr(&mProjection, [mTransform scale]);
    PBRotateMatrixPtr(&mProjection, [mTransform angle]);
}


- (void)arrangeVertex
{
    memcpy(mVertices, mSetupVertices, kMeshVertexSize * sizeof(GLfloat));

    if (mProjectionPackEnabled)
    {
        PBVertex3 sVertex = PBTranslateFromMatrix(mProjection);
        PBVertex3 sScale  = PBScaleFromMatrix(mProjection);

        PBScaleMeshVertice(mVertices, PBVertex3Make(sScale.x, sScale.y, 1.0f));
        PBRotateMeshVertice(mVertices, PBAngleFromMatrix(mProjection));
        PBMakeMeshVertice(mVertices, mVertices, sVertex.x, sVertex.y, sVertex.z);
    }
    else
    {
        PBScaleMeshVertice(mVertices, [mTransform scale]);
        PBRotateMeshVertice(mVertices, [mTransform angle].z);
        PBMakeMeshVertice(mVertices, mVertices, mPoint.x, mPoint.y, mZPoint);
    }
}


#pragma mark -


- (id)init
{
    self = [super init];

    if (self)
    {
        mPoint            = CGPointZero;
        mMeshRenderOption = kPBMeshRenderOptionDefault;
        mCoordinateMode   = kPBMeshCoordinateNormal;

        memcpy(mCoordinates, gCoordinateNormal, sizeof(GLfloat) * 8);
        
        mProjection = PBMatrixIdentity;
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


- (GLfloat *)originVertices
{
    return mSetupVertices;
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
    if (memcmp(&mSuperProjection, &aProjection, sizeof(PBMatrix)) != 0)
    {
        [mTransform setDirty:YES];
    }

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


- (PBMatrix *)superProjectionPtr
{
    return &mSuperProjection;
}


- (void)setSceneProjection:(PBMatrix)aSceneProjection
{
    mSceneProjection = aSceneProjection;
}


- (PBMatrix)sceneProjection
{
    return mSceneProjection;
}


- (void)setTexture:(PBTexture *)aTexture
{
    if (mTexture != aTexture)
    {
        [PBContext performBlockOnMainThread:^{
            [self setProgram:[[PBProgramManager sharedManager] program]];
        }];
        
        [mTexture autorelease];
        mTexture    = [aTexture retain];
        mVertexSize = [mTexture size];
        [self updateMeshData];
    }
}


- (PBTexture *)texture
{
    return mTexture;
}


- (void)setVertexSize:(CGSize)aSize
{
    if (!mTexture)
    {
        [PBContext performBlockOnMainThread:^{
            [self setProgram:[[PBProgramManager sharedManager] colorProgram]];
        }];
    }
    
    mVertexSize = aSize;
    [self updateMeshData];
}


- (CGSize)vertexSize
{
    return mVertexSize;
}


- (void)setTransform:(PBTransform *)aTransform
{
    if (mTransform != aTransform)
    {
        [mTransform autorelease];
        mTransform = [aTransform retain];
    }

    if ([mTransform checkDirty])
    {
        [self arrangeMatrix];
        [self arrangeVertex];
    }
}


- (PBTransform *)transform
{
    return mTransform;
}


- (void)setColor:(PBColor *)aColor
{
    if (mColor != aColor)
    {
        [mColor autorelease];
        mColor = [aColor retain];
    }
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
    PBMatrix sMatrix = PBMultiplyMatrix(mProjection, mSceneProjection);
    glUniformMatrix4fv([mProgram location].projectionLoc, 1, 0, &sMatrix.m[0]);
}


- (void)applySuperProjection
{
    PBMatrix sMatrix = PBMultiplyMatrix(mSuperProjection, mSceneProjection);
    glUniformMatrix4fv([mProgram location].projectionLoc, 1, 0, &sMatrix.m[0]);
}


- (void)applySceneProjection
{
    PBMatrix sMatrix = PBMultiplyMatrix(PBMatrixIdentity, mSceneProjection);
    glUniformMatrix4fv([mProgram location].projectionLoc, 1, 0, &sMatrix.m[0]);
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
    if (!CGSizeEqualToSize([self vertexSize], CGSizeZero) || [mProgram mode] == kPBProgramModeManual)
    {
        [[PBMeshRenderer sharedManager] addMesh:self];
    }
}


@end
