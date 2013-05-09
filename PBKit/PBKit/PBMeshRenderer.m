/*
 *  PBMeshRenderer.m
 *  PBKit
 *
 *  Created by camelkode on 13. 3. 29..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>
#import "PBTexture.h"
#import "PBMeshRenderer.h"
#import "PBMesh.h"
#import "PBMeshArray.h"
#import "PBProgram.h"
#import "PBTransform.h"
#import "PBKit.h"
#import "PBObjCUtil.h"


#define kMaxMeshQueueCount 500


static inline void PBMakeMeshVertice(GLfloat *aDst, GLfloat *aSrc, GLfloat aOffsetX, GLfloat aOffsetY, GLfloat aPointZ)
{
    aDst[0]  = aSrc[0] + aOffsetX;
    aDst[1]  = aSrc[1] + aOffsetY;
    aDst[2]  = aSrc[2] + aPointZ;
    aDst[3]  = aSrc[3] + aOffsetX;
    aDst[4]  = aSrc[4] + aOffsetY;
    aDst[5]  = aSrc[5] + aPointZ;
    aDst[6]  = aSrc[6] + aOffsetX;
    aDst[7]  = aSrc[7] + aOffsetY;
    aDst[8]  = aSrc[8] + aPointZ;
    aDst[9]  = aSrc[9] + aOffsetX;
    aDst[10] = aSrc[10] + aOffsetY;
    aDst[11] = aSrc[11] + aPointZ;
}


static inline void PBScaleMeshVertice(GLfloat *aDst, GLfloat aScale)
{
    aDst[0]  *= aScale;
    aDst[1]  *= aScale;
    aDst[3]  *= aScale;
    aDst[4]  *= aScale;
    aDst[6]  *= aScale;
    aDst[7]  *= aScale;
    aDst[9]  *= aScale;
    aDst[10] *= aScale;
}


static inline void PBRotateMeshVertice(GLfloat *aDst, GLfloat aAngle)
{
    CGPoint sPoint;
    CGFloat sRadian = PBDegreesToRadians(aAngle);

    for (int i = 0; i < kMeshVertexSize; i++)
    {
        sPoint.x    = cosf(sRadian) * aDst[i] + sinf(sRadian) * aDst[i + 1];
        sPoint.y    = -sinf(sRadian) * aDst[i] + cosf(sRadian) * aDst[i + 1];
        aDst[i]     = sPoint.x;
        aDst[i + 1] = sPoint.y;
        i += 2;
    }
}


static inline void PBInitIndicesQueue(GLushort *aIndices, GLint aDrawIndicesSize, GLint aIndicesSize)
{
    NSInteger sVertexOffset  = 0;
    NSInteger sIndicesOffset = 0;
    for (int i = 0; i < aDrawIndicesSize; i++)
    {
        if ((i % aIndicesSize) == 0 && i != 0)
        {
            sIndicesOffset = 0;
            sVertexOffset += kMeshVertexCount;
        }
        
        aIndices[i] = gIndices[sIndicesOffset] + sVertexOffset;
        sIndicesOffset++;
    }
}


@implementation PBMeshRenderer
{
    NSMutableArray *mMeshes;
    BOOL            mSelectionMode;

    // for mesh queue
    GLfloat        *mVerticesQueue;
    GLfloat        *mCoordinatesQueue;
    GLushort       *mIndicesQueue;
    NSUInteger      mQueueCount;
    NSUInteger      mMaxQueueCount;
    NSUInteger      mVertexQueueBufferSize;
    NSUInteger      mCoordinateQueueBufferSize;
    PBMesh         *mSampleQueueMesh;
}


SYNTHESIZE_SINGLETON_CLASS(PBMeshRenderer, sharedManager)


#pragma mark -


- (void)setupMeshQueue
{
    if (mVerticesQueue)
    {
        free(mVerticesQueue);
    }
    
    if (mCoordinatesQueue)
    {
        free(mCoordinatesQueue);
    }
    
    mVertexQueueBufferSize     = mMaxQueueCount * kMeshVertexCount * kMeshVertexSize;
    mCoordinateQueueBufferSize = mMaxQueueCount * kMeshVertexCount * kMeshCoordinateSize;
    mVerticesQueue             = calloc(mVertexQueueBufferSize, sizeof(GLfloat));
    mCoordinatesQueue          = calloc(mCoordinateQueueBufferSize, sizeof(GLfloat));
    mIndicesQueue              = calloc(mMaxQueueCount * sizeof(gIndices) / sizeof(gIndices[0]), sizeof(GLushort));
    
    PBInitIndicesQueue(mIndicesQueue, mMaxQueueCount * sizeof(gIndices) / sizeof(gIndices[0]), sizeof(gIndices) / sizeof(gIndices[0]));
}


- (void)setMaxMeshQueueCount:(NSInteger)aCount
{
    mMaxQueueCount = aCount;
    [self setupMeshQueue];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mMeshes        = [[NSMutableArray alloc] init];
        mMaxQueueCount = kMaxMeshQueueCount;
        [self setupMeshQueue];
    }
    
    return self;
}


#pragma mark -


- (void)pushQueueForMesh:(PBMesh *)aMesh
{
    mSampleQueueMesh = aMesh;
    
    GLfloat   sTransformVertices[kMeshVertexSize];
    PBVertex3 sTranslate = [[aMesh transform] translate];
    
    memcpy(sTransformVertices, [aMesh vertices], kMeshVertexSize * sizeof(GLfloat));

    PBScaleMeshVertice(sTransformVertices, [[aMesh transform] scale]);
    PBRotateMeshVertice(sTransformVertices, [[aMesh transform] angle].z);
    PBMakeMeshVertice(&mVerticesQueue[mQueueCount * kMeshVertexSize], sTransformVertices, sTranslate.x, sTranslate.y, [aMesh zPoint]);
    
    memcpy(&mCoordinatesQueue[mQueueCount * kMeshCoordinateSize], [aMesh coordinates], kMeshCoordinateSize * sizeof(GLfloat));  // TODO : coordinates는 항상 같은 값이 아닌가?
    mQueueCount++;
}


- (void)drawMesh:(PBMesh *)aMesh
{
    if (mSelectionMode)
    {
        [[[PBProgramManager sharedManager] selectionProgram] use];
    }
    else
    {
        [[aMesh program] use];
    }

    [aMesh applyTransform];
    [aMesh applyColor];

    if ([aMesh texture])
    {
        glBindTexture(GL_TEXTURE_2D, [[aMesh texture] handle]);
    }
    
    GLuint sVertexArray = [[aMesh meshArray] vertexArray];
    if (sVertexArray)
    {
        glBindVertexArrayOES(sVertexArray);
        glDrawElements(GL_TRIANGLE_STRIP, sizeof(gIndices) / sizeof(gIndices[0]), GL_UNSIGNED_SHORT, 0);
        glBindVertexArrayOES(0);
    }
}


- (void)drawMeshQueue
{
    PBProgram *sProgram       = [mSampleQueueMesh program];
    GLuint     sTextureHandle = [[mSampleQueueMesh texture] handle];
    
    [sProgram use];
    glBindTexture(GL_TEXTURE_2D, sTextureHandle);
    [mSampleQueueMesh applySuperTransform];
    [mSampleQueueMesh applyColor];

    glVertexAttribPointer([sProgram location].positionLoc, kMeshPositionAttrSize, GL_FLOAT, GL_FALSE, 0, mVerticesQueue);
    glVertexAttribPointer([sProgram location].texCoordLoc, kMeshTexCoordAttrSize, GL_FLOAT, GL_FALSE, 0, mCoordinatesQueue);
    glEnableVertexAttribArray([sProgram location].positionLoc);
    glEnableVertexAttribArray([sProgram location].texCoordLoc);
    
    glDrawElements(GL_TRIANGLES, mQueueCount * sizeof(gIndices) / sizeof(gIndices[0]), GL_UNSIGNED_SHORT, mIndicesQueue);
    
    glDisableVertexAttribArray([sProgram location].positionLoc);
    glDisableVertexAttribArray([sProgram location].texCoordLoc);

    mQueueCount      = 0;
    mSampleQueueMesh = nil;
    
//    memset(mVerticesQueue, 0, mVertexQueueBufferSize);
//    memset(mCoordinatesQueue, 0, mCoordinateQueueBufferSize);
}


#pragma mark -


- (void)addMesh:(PBMesh *)aMesh
{
    [mMeshes addObject:aMesh];
}


- (void)removeMesh:(PBMesh *)aMesh
{
    [mMeshes removeObject:aMesh];
}


- (void)setSelectionMode:(BOOL)aSelectionMode
{
    mSelectionMode = aSelectionMode;
}


- (void)vacate
{
    [mMeshes removeAllObjects];
}


- (void)renderForSelection
{
    for (PBMesh *sMesh in mMeshes)
    {
        [self drawMesh:sMesh];
    }
}


- (void)render
{
    if (mSelectionMode)
    {
        [self renderForSelection];
    }
    else
    {
        for (PBMesh *sMesh in mMeshes)
        {
            PBMeshRenderOption sOption = [sMesh meshRenderOption];
            
            if (sOption == kPBMeshRenderOptionUsingMeshQueue)
            {
                if (([[sMesh texture] handle] != [[mSampleQueueMesh texture] handle]) || mQueueCount >= mMaxQueueCount)
                {
                    [self drawMeshQueue];
                }
                [self pushQueueForMesh:sMesh];
            }
            else if (sOption == kPBMeshRenderOptionUsingMesh)
            {
                if (mQueueCount > 0)
                {
                    [self drawMeshQueue];
                }
                [self drawMesh:sMesh];
            }
            else
            {
                if (mQueueCount > 0)
                {
                    [self drawMeshQueue];
                }
                [sMesh performMeshRenderCallback];
            }
        }

        if (mQueueCount > 0)
        {
            [self drawMeshQueue];
        }
    }

    [self vacate];
}


@end