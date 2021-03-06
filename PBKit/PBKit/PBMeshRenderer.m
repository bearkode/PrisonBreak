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
#import "PBMergeMesh.h"
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


#define kMaxMeshQueueCount 10000
#define kMaxMeshBufferSize 10000


@implementation PBMeshRenderer
{
    id              mMeshes[kMaxMeshBufferSize];
    NSUInteger      mMeshIndex;
    BOOL            mSelectionMode;
    
    GLfloat        *mVerticesQueue;
    GLfloat        *mCoordinatesQueue;
    GLushort       *mIndicesQueue;
    uint32_t        mQueueCount;
    uint32_t        mMaxQueueCount;
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
    
    mVertexQueueBufferSize     = mMaxQueueCount * kMeshVertexSize;
    mCoordinateQueueBufferSize = mMaxQueueCount * kMeshCoordinateSize;
    mVerticesQueue             = calloc(mVertexQueueBufferSize, sizeof(GLfloat));
    mCoordinatesQueue          = calloc(mCoordinateQueueBufferSize, sizeof(GLfloat));
    mIndicesQueue              = calloc(mMaxQueueCount * sizeof(gIndices) / sizeof(gIndices[0]), sizeof(GLushort));
    
    PBInitIndicesQueue(mIndicesQueue, mMaxQueueCount * sizeof(gIndices) / sizeof(gIndices[0]), sizeof(gIndices) / sizeof(gIndices[0]));
}


- (void)setMaxMeshQueueCount:(NSInteger)aCount
{
    mMaxQueueCount = (uint32_t)aCount;
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
    if (!mSampleQueueMesh)
    {
        return YES;
    }
    
    BOOL      sIsClusterTexture      = ([[aMesh texture] handle] == [[mSampleQueueMesh texture] handle]) ? YES : NO;
    BOOL      sIsClusterColor        = ([aMesh color]) ? [[aMesh color] isEqualToColor:[mSampleQueueMesh color]] : ([mSampleQueueMesh color]) ? NO : YES;
    BOOL      sIsManualProgram       = ([[aMesh program] mode] == kPBProgramModeManual) ? YES : NO;
    BOOL      sIsEqualOriginPoint    = YES;
    PBMatrix *sSuperProjection       = [aMesh superProjectionPtr];
    PBMatrix *sSampleSuperProjection = [mSampleQueueMesh superProjectionPtr];
    
    if ([aMesh projectionPackEnabled])
    {
        NSRange sOrder = [aMesh projectionPackOrder];
        if (sOrder.length <= mQueueCount)
        {
            return NO;
        }
    }
    else
    {
        if (sSampleSuperProjection)
        {
            if (sSuperProjection->m[12] != sSampleSuperProjection->m[12] ||
                sSuperProjection->m[13] != sSampleSuperProjection->m[13])
            {
                sIsEqualOriginPoint = NO;
            }
        }
    }
    
    return (sIsClusterTexture && sIsClusterColor && sIsEqualOriginPoint && !sIsManualProgram) ? YES : NO;
}


- (void)pushQueueForMesh:(PBMesh *)aMesh
{
    mSampleQueueMesh = aMesh;

    NSUInteger sVerticesQueueOffset    = ([aMesh projectionPackEnabled]) ? [aMesh projectionPackOrder].location * kMeshVertexSize : mQueueCount * kMeshVertexSize;
    NSUInteger sCoordinatesQueueOffset = ([aMesh projectionPackEnabled]) ? [aMesh projectionPackOrder].location * kMeshCoordinateSize : mQueueCount * kMeshCoordinateSize;

    memcpy(&mVerticesQueue[sVerticesQueueOffset], [aMesh vertices], kMeshVertexSize * sizeof(GLfloat));
    memcpy(&mCoordinatesQueue[sCoordinatesQueueOffset], [aMesh coordinates], kMeshCoordinateSize * sizeof(GLfloat));
    
    mQueueCount++;
    NSAssert(mQueueCount < kMaxMeshBufferSize, @"");
}


- (void)pushQueueForMergedMesh:(PBMergeMesh *)aMesh
{
    mSampleQueueMesh = aMesh;
    mQueueCount      = [aMesh meshCount];
    NSAssert(mQueueCount < kMaxMeshBufferSize, @"");
}


- (void)drawMesh:(PBMesh *)aMesh program:(PBProgram *)aProgram
{
    ([aMesh projectionPackEnabled]) ? [aMesh applySceneProjection] : [aMesh applySuperProjection];
    [aMesh applyColor];
    
    GLfloat *sVertices    = ([aMesh meshRenderOption] == kPBMeshRenderOptionMerged) ? [aMesh vertices] : mVerticesQueue;
    GLfloat *sCoordinates = ([aMesh meshRenderOption] == kPBMeshRenderOptionMerged) ? [aMesh coordinates] : mCoordinatesQueue;
    
    glVertexAttribPointer([aProgram location].positionLoc, kMeshPositionAttrSize, GL_FLOAT, GL_FALSE, 0, sVertices);
    glVertexAttribPointer([aProgram location].texCoordLoc, kMeshTexCoordAttrSize, GL_FLOAT, GL_FALSE, 0, sCoordinates);
    glEnableVertexAttribArray([aProgram location].positionLoc);
    glEnableVertexAttribArray([aProgram location].texCoordLoc);
    
    glDrawElements(GL_TRIANGLES, mQueueCount * sizeof(gIndices) / sizeof(gIndices[0]), GL_UNSIGNED_SHORT, mIndicesQueue);
    
    glDisableVertexAttribArray([aProgram location].positionLoc);
    glDisableVertexAttribArray([aProgram location].texCoordLoc);
}


- (void)renderMeshQueue
{
    if (mQueueCount <= 0)
    {
        return;
    }
    
    PBMesh    *sMesh    = mSampleQueueMesh;
    PBProgram *sProgram = (mSelectionMode) ? [[PBProgramManager sharedManager] selectionProgram] : [sMesh program];
    [sProgram use];
    
    glBindTexture(GL_TEXTURE_2D, [[sMesh texture] handle]);
    switch ([sProgram mode])
    {
        case kPBProgramModeSemiauto:
            if ([[sProgram delegate] respondsToSelector:@selector(pbProgramWillSemiautoDraw:)])
            {
                [[sProgram delegate] pbProgramWillSemiautoDraw:sProgram];
                [self drawMesh:sMesh program:sProgram];
            }
            break;
        case kPBProgramModeManual:
            [sMesh applySuperProjection];
            if ([[sProgram delegate] respondsToSelector:@selector(pbProgramWillManualDraw:)])
            {
                [[sProgram delegate] pbProgramWillManualDraw:sProgram];
            }
            break;
        default:
            [self drawMesh:sMesh program:sProgram];
            break;
    }
    glBindTexture(GL_TEXTURE_2D, 0);
    
    if (gRenderTesting)
    {
        gRenderTestReport.testVertexCount += mQueueCount * kMeshVertexSize;
        gRenderTestReport.testDrawCallCount++;
        gRenderTestReport.testDrawMeshQueueCallCount++;
    }
    
    mQueueCount      = 0;
    mSampleQueueMesh = nil;
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
    PBProgram *sProgram = [[PBProgramManager sharedManager] normalProgram];
    [sProgram use];
    
    glBindTexture(GL_TEXTURE_2D, aHandle);
    
    PBMatrix sProjection = [PBMatrixOperator orthoMatrix:PBMatrixIdentity
                                                    left:-(aCanvasSize.width / 2)
                                                   right:(aCanvasSize.width / 2)
                                                  bottom:-(aCanvasSize.height / 2)
                                                     top:(aCanvasSize.height / 2)
                                                    near:1000 far:-1000];
    GLfloat sColors[4] = {1.0, 1.0, 1.0, 1.0};
    glVertexAttrib4fv([sProgram location].colorLoc, sColors);
    glUniformMatrix4fv([sProgram location].projectionLoc, 1, 0, &sProjection.m[0]);
    glVertexAttribPointer([sProgram location].texCoordLoc, 2, GL_FLOAT, GL_FALSE, 0, gCoordinateFlipVertical);
    glEnableVertexAttribArray([sProgram location].texCoordLoc);
    
    GLfloat sPointZ = 2.0f;
    GLfloat sVertices[12];
    PBMakeMeshVertiesMakeFromSize(sVertices, aCanvasSize.width / 2, aCanvasSize.height / 2, sPointZ);
    
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
        gRenderTestReport.testMeshesCount = (GLint)mMeshIndex;
    }
    
    for (NSInteger i = 0; i < mMeshIndex; i++)
    {
        PBMesh            *sMesh   = mMeshes[i];
        PBMeshRenderOption sOption = [sMesh meshRenderOption];
        
        switch (sOption)
        {
            case kPBMeshRenderOptionDefault:
            {
                if (![self isClusterMesh:sMesh] || mQueueCount >= mMaxQueueCount)
                {
                    [self renderMeshQueue];
                }
                [self pushQueueForMesh:sMesh];
            }
                break;
            case kPBMeshRenderOptionImmediately:
            {
                [self renderMeshQueue];
                [self pushQueueForMesh:sMesh];
                [self renderMeshQueue];
            }
                break;
            case kPBMeshRenderOptionMerged:
            {
                [self renderMeshQueue];
                [self pushQueueForMergedMesh:(PBMergeMesh *)sMesh];
                [self renderMeshQueue];
            }
                break;
            default:
                NSAssert(NO, @"Exception occur. check to MeshRender type");
                break;
        }
    }
    
    [self renderMeshQueue];
    [self vacate];
}


@end