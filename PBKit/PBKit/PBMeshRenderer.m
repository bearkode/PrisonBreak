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


static inline void makeMeshVertice(GLfloat *aDst, GLfloat *aSrc, PBVertex3 aVertex)
{
    memcpy(aDst, aSrc, kMeshVertexSize * sizeof(GLfloat));
    aDst[0]  += aVertex.x;
    aDst[1]  += aVertex.y;
    aDst[2]  += aVertex.z;
    aDst[3]  += aVertex.x;
    aDst[4]  += aVertex.y;
    aDst[5]  += aVertex.z;
    aDst[6]  += aVertex.x;
    aDst[7]  += aVertex.y;
    aDst[8]  += aVertex.z;
    aDst[9]  += aVertex.x;
    aDst[10] += aVertex.y;
    aDst[11] += aVertex.z;
}


static inline void rotateMeshVertice(GLfloat *aDst, GLfloat aAngle)
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


static inline void initIndicesQueue(GLushort *aIndices, GLint aDrawIndicesSize, GLint aIndicesSize)
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
    initIndicesQueue(mIndicesQueue, mMaxQueueCount * sizeof(gIndices) / sizeof(gIndices[0]), sizeof(gIndices) / sizeof(gIndices[0]));
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
    
    GLfloat sTransformVertices[kMeshVertexSize];
    memcpy(sTransformVertices, [aMesh vertices], kMeshVertexSize * sizeof(GLfloat));
    rotateMeshVertice(sTransformVertices, [[aMesh tranform] angle].z);
    makeMeshVertice(&mVerticesQueue[mQueueCount * kMeshVertexSize], sTransformVertices, [[aMesh tranform] translate]);
    
    memcpy(&mCoordinatesQueue[mQueueCount * kMeshCoordinateSize], [aMesh coordinates], kMeshCoordinateSize * sizeof(GLfloat));

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
    if (mQueueCount == 0 || !mSampleQueueMesh)
    {
        return;
    }

    PBProgram *sProgram = [mSampleQueueMesh program];
    if (mSelectionMode)
    {
        sProgram = [[PBProgramManager sharedManager] selectionProgram];
    }
    else
    {
        [sProgram use];
    }
    
    GLuint     sTextureHandle = [[mSampleQueueMesh texture] handle];
    [mSampleQueueMesh applySuperTransform];
    
    glBindTexture(GL_TEXTURE_2D, sTextureHandle);
    [mSampleQueueMesh applyColor];

    glVertexAttribPointer([sProgram location].positionLoc, kMeshPositionAttrSize, GL_FLOAT, GL_FALSE, 0, mVerticesQueue);
    glVertexAttribPointer([sProgram location].texCoordLoc, kMeshTexCoordAttrSize, GL_FLOAT, GL_FALSE, 0, mCoordinatesQueue);
    glEnableVertexAttribArray([sProgram location].positionLoc);
    glEnableVertexAttribArray([sProgram location].texCoordLoc);
    
    glDrawElements(GL_TRIANGLES, mQueueCount * sizeof(gIndices) / sizeof(gIndices[0]), GL_UNSIGNED_SHORT, mIndicesQueue);
    
    glDisableVertexAttribArray([sProgram location].positionLoc);
    glDisableVertexAttribArray([sProgram location].texCoordLoc);

    mQueueCount = 0;
    mSampleQueueMesh  = nil;
    memset(mVerticesQueue, 0, mVertexQueueBufferSize);
    memset(mCoordinatesQueue, 0, mCoordinateQueueBufferSize);
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


- (void)render
{
//    PBBeginTimeCheck();
    for (PBMesh *sMesh in mMeshes)
    {
        switch ([sMesh meshRenderOption])
        {
            case kPBMeshRenderOptionUsingMesh:
            {
                [self drawMeshQueue];
                [self drawMesh:sMesh];
            }
                break;
            case kPBMeshRenderOptionUsingMeshQueue:
            {
                if (([[sMesh texture] handle] != [[mSampleQueueMesh texture] handle]) ||
                    mQueueCount >= mMaxQueueCount)
                {
                    [self drawMeshQueue];
                }
                [self pushQueueForMesh:sMesh];
            }
                break;
            case kPBMeshRenderOptionUsingCallback:
                [sMesh performMeshRenderCallback];
                break;
            default:
                break;
        }
    }
    [self drawMeshQueue];
    [self vacate];
    
//    PBEndTimeCheck();
}


@end