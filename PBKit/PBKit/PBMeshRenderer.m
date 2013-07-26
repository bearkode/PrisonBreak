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
    
    mVertexQueueBufferSize     = mMaxQueueCount * kMeshVertexSize;
    mCoordinateQueueBufferSize = mMaxQueueCount * kMeshCoordinateSize;
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
    BOOL sIsEqualAnchorPoint = CGPointEqualToPoint([aMesh anchorPoint], [mSampleQueueMesh anchorPoint]);
    BOOL sIsManualProgram    = ([[aMesh program] mode] == kPBProgramModeManual) ? YES : NO;
    
    return (sIsClusterTexture && sIsClusterColor && sIsEqualAnchorPoint && !sIsManualProgram) ? YES : NO;
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


- (void)drawMesh:(PBMesh *)aMesh program:(PBProgram *)aProgram
{
    [aMesh applySuperProjection];
    [aMesh applyColor];
    
    glVertexAttribPointer([aProgram location].positionLoc, kMeshPositionAttrSize, GL_FLOAT, GL_FALSE, 0, mVerticesQueue);
    glVertexAttribPointer([aProgram location].texCoordLoc, kMeshTexCoordAttrSize, GL_FLOAT, GL_FALSE, 0, mCoordinatesQueue);
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
    PBProgram *sProgram = [[PBProgramManager sharedManager] program];
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
        gRenderTestReport.testMeshesCount = mMeshIndex;
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
            default:
                NSAssert(NO, @"Exception occur. check to MeshRender type");
                break;
        }
    }
    
    [self renderMeshQueue];
    [self vacate];
}


@end