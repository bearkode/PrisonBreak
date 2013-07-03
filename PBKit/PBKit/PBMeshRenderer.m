/*
 *  PBMeshRenderer.m
 *  PBKit
 *
 *  Created by camelkode on 13. 3. 29..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "PBMeshRenderer.h"
#import "PBMesh.h"
#import "PBProgram.h"
#import "PBProgramManager.h"
#import "PBTexture.h"
#import "PBTransform.h"
#import "PBObjCUtil.h"
#import "PBRenderTestReport.h"
#import "PBMacro.h"
#import "PBColor.h"


#pragma mark -


GLboolean          gRenderTesting = false;
PBRenderTestReport gRenderTestReport;


#define kMaxMeshQueueCount 500
#define kMaxMeshBufferSize 10000


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
    id              mMeshes[kMaxMeshBufferSize];
    NSUInteger      mMeshIndex;
    BOOL            mSelectionMode;
    
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
        mMeshIndex     = 0;
        mMaxQueueCount = kMaxMeshQueueCount;
        [self setupMeshQueue];
    }
    
    return self;
}


#pragma mark -


- (BOOL)isClusterMesh:(PBMesh *)aMesh
{
    BOOL sIsClusterTexture   = ([[aMesh texture] handle] == [[mSampleQueueMesh texture] handle]) ? YES : NO;
    BOOL sIsClusterColor     = (([aMesh color].r == [mSampleQueueMesh color].r) &&
                                ([aMesh color].g == [mSampleQueueMesh color].g) &&
                                ([aMesh color].b == [mSampleQueueMesh color].b) &&
                                ([aMesh color].a == [mSampleQueueMesh color].a));
    
    BOOL sIsCustomProgram    = ([[aMesh program] type] == kPBProgramCustom) ? YES : NO;
    
    return (sIsClusterTexture && sIsClusterColor && !sIsCustomProgram) ? YES : NO;
}


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


- (void)drawMeshQueue
{
    if (mQueueCount <= 0)
    {
        return;
    }
    
    PBMesh    *sMesh    = mSampleQueueMesh;
    PBProgram *sProgram = nil;
    if (mSelectionMode)
    {
        sProgram = [[PBProgramManager sharedManager] selectionProgram];
    }
    else
    {
        sProgram = [sMesh program];
    }

    GLuint sTextureHandle = [[sMesh texture] handle];
    glBindTexture(GL_TEXTURE_2D, sTextureHandle);
    [sProgram use];

    if ([sProgram type] == kPBProgramCustom)
    {
        if ([[sProgram delegate] respondsToSelector:@selector(pbProgramCustomDraw:mvp:vertices:coordinate:)])
        {
            [[sProgram delegate] pbProgramCustomDraw:sProgram mvp:[sMesh superProjection] vertices:mVerticesQueue coordinate:mCoordinatesQueue];
        }
    }
    else
    {
        [sMesh applySuperTransform];
        [sMesh applyColor];

        glVertexAttribPointer([sProgram location].positionLoc, kMeshPositionAttrSize, GL_FLOAT, GL_FALSE, 0, mVerticesQueue);
        glVertexAttribPointer([sProgram location].texCoordLoc, kMeshTexCoordAttrSize, GL_FLOAT, GL_FALSE, 0, mCoordinatesQueue);
        glEnableVertexAttribArray([sProgram location].positionLoc);
        glEnableVertexAttribArray([sProgram location].texCoordLoc);
        
        glDrawElements(GL_TRIANGLES, mQueueCount * sizeof(gIndices) / sizeof(gIndices[0]), GL_UNSIGNED_SHORT, mIndicesQueue);
        
        glDisableVertexAttribArray([sProgram location].positionLoc);
        glDisableVertexAttribArray([sProgram location].texCoordLoc);
    }

    if (gRenderTesting)
    {
        gRenderTestReport.testVertexCount += mQueueCount * kMeshVertexSize;
        gRenderTestReport.testDrawCallCount++;
        gRenderTestReport.testDrawMeshQueueCallCount++;
    }
    
    mQueueCount      = 0;
    mSampleQueueMesh = nil;
    
    glBindTexture(GL_TEXTURE_2D, 0);
}


#pragma mark -


- (void)addMesh:(PBMesh *)aMesh
{
    mMeshes[mMeshIndex++] = aMesh;
    NSAssert(mMeshIndex < kMaxMeshBufferSize, @"");
}


- (void)setSelectionMode:(BOOL)aSelectionMode
{
    mSelectionMode = aSelectionMode;
}


- (void)vacate
{
    mMeshIndex = 0;
}


#pragma mark -


- (void)renderToTexture:(GLuint)aHandle withCanvasSize:(CGSize)aCanvasSize
{
    PBProgram *sProgram = [[PBProgramManager sharedManager] program];
    [sProgram use];
    
    glBindTexture(GL_TEXTURE_2D, aHandle);
    
    PBMatrix sProjection = [PBMatrixOperator orthoMatrix:PBMatrixIdentity
                                                    left:-(aCanvasSize.width  / 2.0 / 0.5)
                                                   right:(aCanvasSize.width   / 2.0 / 0.5)
                                                  bottom:-(aCanvasSize.height / 2.0 / 0.5)
                                                     top:(aCanvasSize.height  / 2.0 / 0.5)
                                                    near:1000 far:-1000];
    GLfloat sColors[4] = {1.0, 1.0, 1.0, 1.0};
    glVertexAttrib4fv([sProgram location].colorLoc, sColors);
    glUniformMatrix4fv([sProgram location].projectionLoc, 1, 0, &sProjection.m[0]);
    glVertexAttribPointer([sProgram location].texCoordLoc, 2, GL_FLOAT, GL_FALSE, 0, gFlipTexCoordinates);
    glEnableVertexAttribArray([sProgram location].texCoordLoc);
    
    GLfloat sPointZ = 2.0f;
    GLfloat sVertices[] =
    {
        -aCanvasSize.width,  aCanvasSize.height, sPointZ,
        -aCanvasSize.width, -aCanvasSize.height, sPointZ,
         aCanvasSize.width, -aCanvasSize.height, sPointZ,
         aCanvasSize.width,  aCanvasSize.height, sPointZ
    };
    
    glVertexAttribPointer([sProgram location].positionLoc, 3, GL_FLOAT, GL_FALSE, 0, sVertices);
    glEnableVertexAttribArray([sProgram location].positionLoc);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDisableVertexAttribArray([sProgram location].positionLoc);
    glDisableVertexAttribArray([sProgram location].texCoordLoc);
    
    glBindTexture(GL_TEXTURE_2D, 0);
}


- (void)render
{
    if (gRenderTesting)
    {
        PBRenderResetReport();
        gRenderTestReport.testMeshesCount = mMeshIndex;
    }
    
    for (NSInteger i = 0; i < mMeshIndex; i++)
    {
        PBMesh            *sMesh   = mMeshes[i];
        PBMeshRenderOption sOption = [sMesh meshRenderOption];
        
        if (sOption == kPBMeshRenderOptionUsingMeshQueue)
        {
            if (![self isClusterMesh:sMesh] || mQueueCount >= mMaxQueueCount)
            {
                [self drawMeshQueue];
            }
            [self pushQueueForMesh:sMesh];
        }
        else if (sOption == kPBMeshRenderOptionUsingCallback)
        {
            [self drawMeshQueue];
            [sMesh performMeshRenderCallback];
        }
        else
        {
            NSAssert(NO, @"Exception occur. check to MeshRender type");
        }
    }
    
    [self drawMeshQueue];
    [self vacate];
}


@end