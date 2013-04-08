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


static inline void makeMeshVertice(GLfloat *aDst, GLfloat *aSrc, GLint aOffsetX, GLint aOffsetY)
{
    memcpy(aDst, aSrc, kMeshOffsetSize * sizeof(GLfloat));
    aDst[0] += aOffsetX;
    aDst[1] += aOffsetY;
    aDst[2] += aOffsetX;
    aDst[3] += aOffsetY;
    aDst[4] += aOffsetX;
    aDst[5] += aOffsetY;
    aDst[6] += aOffsetX;
    aDst[7] += aOffsetY;
}


static inline void rotateMeshVertice(GLfloat *aDst, GLfloat aAngle)
{
    CGPoint sPoint;
    CGFloat sRadian = PBDegreesToRadians(aAngle);

    for (int i = 0; i < kMeshOffsetSize; i++)
    {
        sPoint.x = cosf(sRadian) * aDst[i] + sinf(sRadian) * aDst[i + 1];
        sPoint.y = -sinf(sRadian) * aDst[i] + cosf(sRadian) * aDst[i + 1];
        aDst[i] = sPoint.x;
        aDst[i + 1] = sPoint.y;
        i += 1;
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
    NSUInteger      mQueueBufferSize;
    PBMesh         *mSampleQueueMesh;
    
//    NSInteger mDrawMethodCallCount;
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
    
    mQueueBufferSize  = mMaxQueueCount * kMeshVertexCount * kMeshOffsetSize;
    mVerticesQueue    = calloc(mQueueBufferSize, sizeof(GLfloat));
    mCoordinatesQueue = calloc(mQueueBufferSize, sizeof(GLfloat));
    mIndicesQueue     = calloc(mMaxQueueCount * sizeof(gIndices) / sizeof(gIndices[0]), sizeof(GLushort));
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
        mMaxQueueCount = 500;
        [self setupMeshQueue];
    }
    
    return self;
}


#pragma mark -


- (void)pushQueueForMesh:(PBMesh *)aMesh
{
    mSampleQueueMesh = aMesh;
    
    GLfloat sTransformVertices[8];
    memcpy(sTransformVertices, [aMesh vertices], kMeshOffsetSize * sizeof(GLfloat));
    rotateMeshVertice(sTransformVertices, [[aMesh tranform] angle].z);
    
    makeMeshVertice(&mVerticesQueue[mQueueCount * kMeshOffsetSize], sTransformVertices, [[aMesh tranform] translate].x, [[aMesh tranform] translate].y);
    memcpy(&mCoordinatesQueue[mQueueCount * kMeshOffsetSize], [aMesh coordinates], kMeshOffsetSize * sizeof(GLfloat));

    mQueueCount++;
}


- (void)drawMesh:(PBMesh *)aMesh
{
    if (mSelectionMode)
    {
        [[[PBProgramManager sharedManager] selectionProgram] use];
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
//        gDrawMethodCallCount++;
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
        [sProgram use];
    }
    
    GLuint     sTextureHandle = [[mSampleQueueMesh texture] handle];
    [mSampleQueueMesh applySuperTransform];
    
    glBindTexture(GL_TEXTURE_2D, sTextureHandle);
    [mSampleQueueMesh applyColor];

    glVertexAttribPointer([sProgram location].positionLoc, 2, GL_FLOAT, GL_FALSE, 0, mVerticesQueue);
    glVertexAttribPointer([sProgram location].texCoordLoc, 2, GL_FLOAT, GL_FALSE, 0, mCoordinatesQueue);
    glEnableVertexAttribArray([sProgram location].positionLoc);
    glEnableVertexAttribArray([sProgram location].texCoordLoc);
    
    glDrawElements(GL_TRIANGLES, mQueueCount * sizeof(gIndices) / sizeof(gIndices[0]), GL_UNSIGNED_SHORT, mIndicesQueue);
//    NSLog(@"gPushedQueueCount = %d", gPushedQueueCount);
//    gDrawMethodCallCount++;
    
    glDisableVertexAttribArray([sProgram location].positionLoc);
    glDisableVertexAttribArray([sProgram location].texCoordLoc);

    mQueueCount = 0;
    mSampleQueueMesh  = nil;
    memset(mVerticesQueue, 0, mQueueBufferSize);
    memset(mCoordinatesQueue, 0, mQueueBufferSize);
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
//    mDrawMethodCallCount = 0;
//    PBBeginTimeCheck();
    for (PBMesh *sMesh in mMeshes)
    {
        if ([sMesh isUsingMeshQueue])
        {
            if (([[sMesh texture] handle] != [[mSampleQueueMesh texture] handle]) ||
                mQueueCount >= mMaxQueueCount)
            {
                [self drawMeshQueue];
            }

            [self pushQueueForMesh:sMesh];
        }
        else
        {
            [self drawMeshQueue];
            [self drawMesh:sMesh];
        }
    }
    [self drawMeshQueue];
    [self vacate];
    
//    PBEndTimeCheck();
//    NSLog(@"draw method call count = %d", gDrawMethodCallCount);
}


@end