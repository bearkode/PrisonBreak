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


static NSMutableArray *gMeshes           = nil;
static GLfloat        *gVerticesQueue    = nil;
static GLfloat        *gCoordinatesQueue = nil;
static GLushort       *gIndicesQueue     = nil;
static NSInteger       gPushedQueueCount = 0;
static NSInteger       gQueueOffset      = 0;
static NSInteger       gQueueSize        = 0;
static NSInteger       gMaxQueueCount    = 500;
static PBMesh         *gSampleQueueMesh  = nil;
static BOOL            gSelectionMode    = NO;

//NSInteger gDrawMethodCallCount;


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


#pragma mark -


+ (void)setupMeshQueue
{
    if (gVerticesQueue)
    {
        free(gVerticesQueue);
    }
    
    if (gCoordinatesQueue)
    {
        free(gCoordinatesQueue);
    }
    
    gQueueSize        = gMaxQueueCount * kMeshVertexCount * kMeshOffsetSize;
    gVerticesQueue    = calloc(gQueueSize, sizeof(GLfloat));
    gCoordinatesQueue = calloc(gQueueSize, sizeof(GLfloat));
    gIndicesQueue     = calloc(gMaxQueueCount * sizeof(gIndices) / sizeof(gIndices[0]), sizeof(GLushort));
    initIndicesQueue(gIndicesQueue, gMaxQueueCount * sizeof(gIndices) / sizeof(gIndices[0]), sizeof(gIndices) / sizeof(gIndices[0]));
}


+ (void)setMaxMeshQueueCount:(NSInteger)aCount
{
    gMaxQueueCount = aCount;
    [PBMeshRenderer setupMeshQueue];
}


#pragma mark -


+ (void)initialize
{
    gMeshes = [[NSMutableArray alloc] init];
    [PBMeshRenderer setupMeshQueue];
}


#pragma mark -




+ (CGPoint)rotatePoint:(CGPoint)vertex byRadians:(float)radians center:(CGPoint)center
{
    float deltaX = vertex.x - center.x;
    float deltaY = vertex.y - center.y;
    float currentAngle = atan2f(deltaY, deltaX);
    float newAngle = currentAngle - radians;
    float radious = sqrtf(powf(deltaX, 2.0) + powf(deltaY, 2.0));
    float newX = radious * cosf(newAngle) + vertex.x;
    float newY = -1.0 * radious * sinf(newAngle) + vertex.y;
    return CGPointMake(newX, newY);
}


+ (void)pushQueueForMesh:(PBMesh *)aMesh
{
    GLfloat *sVertices   = [aMesh vertices];
    gSampleQueueMesh     = aMesh;
    PBVertex3 sTranslate = [[aMesh tranform] translate];
    
    GLfloat sTransformVertices[8];
    memcpy(sTransformVertices, sVertices, kMeshOffsetSize * sizeof(GLfloat));
    rotateMeshVertice(sTransformVertices, [[aMesh tranform] angle].z);
    
    makeMeshVertice(&gVerticesQueue[gQueueOffset], sTransformVertices, sTranslate.x, sTranslate.y);
    memcpy(&gCoordinatesQueue[gQueueOffset], [aMesh coordinates], kMeshOffsetSize * sizeof(GLfloat));
    gQueueOffset += kMeshOffsetSize;
    gPushedQueueCount++;
}


+ (void)drawMesh:(PBMesh *)aMesh
{
    if (gSelectionMode)
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


+ (void)drawMeshQueue
{
    if (gQueueOffset == 0 || !gSampleQueueMesh)
    {
        return;
    }

    PBProgram *sProgram = [gSampleQueueMesh program];
    if (gSelectionMode)
    {
        sProgram = [[PBProgramManager sharedManager] selectionProgram];
        [sProgram use];
    }
    
    GLuint     sTextureHandle = [[gSampleQueueMesh texture] handle];
    [gSampleQueueMesh applySuperTransform];
    
    glBindTexture(GL_TEXTURE_2D, sTextureHandle);
    [gSampleQueueMesh applyColor];

    glVertexAttribPointer([sProgram location].positionLoc, 2, GL_FLOAT, GL_FALSE, 0, gVerticesQueue);
    glVertexAttribPointer([sProgram location].texCoordLoc, 2, GL_FLOAT, GL_FALSE, 0, gCoordinatesQueue);
    glEnableVertexAttribArray([sProgram location].positionLoc);
    glEnableVertexAttribArray([sProgram location].texCoordLoc);
    
    glDrawElements(GL_TRIANGLES, gPushedQueueCount * sizeof(gIndices) / sizeof(gIndices[0]), GL_UNSIGNED_SHORT, gIndicesQueue);
//    NSLog(@"gPushedQueueCount = %d", gPushedQueueCount);
//    gDrawMethodCallCount++;
    
    glDisableVertexAttribArray([sProgram location].positionLoc);
    glDisableVertexAttribArray([sProgram location].texCoordLoc);

    gQueueOffset     = 0;
    gPushedQueueCount = 0;
    gSampleQueueMesh = nil;
    memset(gVerticesQueue, 0, gQueueSize);
    memset(gCoordinatesQueue, 0, gQueueSize);
}


#pragma mark -


+ (void)addMesh:(PBMesh *)aMesh
{
    [gMeshes addObject:aMesh];
}


+ (void)removeMesh:(PBMesh *)aMesh
{
    [gMeshes removeObject:aMesh];
}


+ (void)setSelectionMode:(BOOL)aSelectionMode
{
    gSelectionMode = aSelectionMode;
}


+ (void)vacate
{
    [gMeshes removeAllObjects];
}


+ (void)render
{
//    gDrawMethodCallCount = 0;
//    PBBeginTimeCheck();
    for (PBMesh *sMesh in gMeshes)
    {
        if ([sMesh isUsingMeshQueue])
        {
            if (([[sMesh texture] handle] != [[gSampleQueueMesh texture] handle]) ||
                gPushedQueueCount >= gMaxQueueCount)
            {
                [PBMeshRenderer drawMeshQueue];
            }

            [PBMeshRenderer pushQueueForMesh:sMesh];
        }
        else
        {
            [PBMeshRenderer drawMeshQueue];
            [PBMeshRenderer drawMesh:sMesh];
        }
    }
    [PBMeshRenderer drawMeshQueue];
    [PBMeshRenderer vacate];
    
//    PBEndTimeCheck();
//    NSLog(@"draw method call count = %d", gDrawMethodCallCount);
}


@end