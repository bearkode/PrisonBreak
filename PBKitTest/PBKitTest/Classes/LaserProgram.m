/*
 *  LaserProgram.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 11..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBKit.h>
#import <PBVertices.h>
#import "LaserProgram.h"


#define kMaxLines   40
#define kFlashAlpha 0.9


typedef struct {
    GLint projectionLoc;
    GLint positionLoc;
    GLint CoordinateLoc;
    GLint resolutionLoc;
    GLint timeLoc;
    GLint alphaLoc;
    GLint colorLoc;
    
} LaserLocation;


@implementation LaserProgram
{
    LaserLocation mLocation;
    PBCamera     *mCamera;
    GLfloat       mAlpha;
    
    GLfloat      *mVerticesQueue;
    GLfloat      *mCoordinatesQueue;
    GLushort     *mIndicesQueue;
    
    GLint             mDrawLines;
    
    PBColor          *mColor;
    CGPoint           mStartPoint;
    CGPoint           mEndPoint;
    CGFloat           mBaseAngle;
    BOOL              mFire;
}


@synthesize startPoint = mStartPoint;
@synthesize endPoint   = mEndPoint;
@synthesize color      = mColor;


#pragma mark -


- (void)generatorLaserWithStartPoint:(CGPoint)aStartPoint endPoint:(CGPoint)aEndPoint
{
    CGPoint sBaseOffset = CGPointMake(aEndPoint.x - aStartPoint.x, aEndPoint.y - aStartPoint.y);
    sBaseOffset.x = sBaseOffset.x / kMaxLines;
    sBaseOffset.y = sBaseOffset.y / kMaxLines;
    sBaseOffset.x *= 0.5;
    sBaseOffset.y *= 0.5;
    
    GLfloat sThick  = kMaxLines * 2;
    CGPoint sHeadPoint = aStartPoint;
    CGPoint sTailPoint = aStartPoint;
    for (int i = 0; i < kMaxLines; i++)
    {
        sTailPoint.x = sHeadPoint.x + sBaseOffset.x;
        sTailPoint.y = sHeadPoint.y + sBaseOffset.y;
//        NSLog(@"%@", NSStringFromCGPoint(sHeadPoint));
//        NSLog(@"%@", NSStringFromCGPoint(sTailPoint));

        GLfloat sVertices[kMeshVertexSize];
        GLfloat sDistance = sqrtf(powf(sTailPoint.x - sHeadPoint.x, 2) + powf(sTailPoint.y - sHeadPoint.y, 2));
        CGPoint sOffset = sHeadPoint;//CGPointMake(sHeadPoint.x + sBaseOffset.x, sHeadPoint.y + sBaseOffset.y);
        sOffset.x += sBaseOffset.x * (i + 1);
        sOffset.y += sBaseOffset.y * (i + 1);

        sThick--;

        PBMakeMeshVertiesMakeFromSize(sVertices, sDistance, sThick, 0.0f);
        PBRotateMeshVertice(sVertices, mBaseAngle);
        

        PBMakeMeshVertice(sVertices, sVertices, sOffset.x, sOffset.y, 0);
        
        memcpy(&mVerticesQueue[i * kMeshVertexSize], sVertices, kMeshVertexSize * sizeof(GLfloat));
        memcpy(&mCoordinatesQueue[i * kMeshCoordinateSize], gCoordinateNormal, kMeshCoordinateSize * sizeof(GLfloat));
        
        sHeadPoint = sTailPoint;
    }
}


//- (void)generatorLaserWithStartPoint:(CGPoint)aStartPoint endPoint:(CGPoint)aEndPoint
//{
//    GLfloat sVertices[kMeshVertexSize];
//    CGFloat sDistance = sqrtf(powf(aEndPoint.x - aStartPoint.x, 2) + powf(aEndPoint.y - aStartPoint.y, 2));
//    GLfloat sLength      = sDistance;
//    GLfloat sThickness   = 20.0f;
//    CGSize  sVerticeSize = CGSizeMake(sLength, sThickness);
//    
//    PBMakeMeshVertiesMakeFromSize(sVertices, sVerticeSize.width/2, sVerticeSize.height, 0.0f);
//    PBRotateMeshVertice(sVertices, mBaseAngle);
//    
//    CGPoint sOffset;
//    sOffset.x = aStartPoint.x + (sVertices[6] + sVertices[9]) / 2;
//    sOffset.y = aStartPoint.y + (sVertices[7] + sVertices[10]) / 2;
//    PBMakeMeshVertice(sVertices, sVertices, sOffset.x, sOffset.y, 0);
//    
//    memcpy(&mVerticesQueue[kMeshVertexSize], sVertices, kMeshVertexSize * sizeof(GLfloat));
//    memcpy(&mCoordinatesQueue[kMeshCoordinateSize], gCoordinateNormal, kMeshCoordinateSize * sizeof(GLfloat));
//}


#pragma mark -


- (void)bindLocation
{
    mLocation.positionLoc   = [self attributeLocation:@"aPosition"];
    mLocation.CoordinateLoc = [self attributeLocation:@"aCoordinate"];
    mLocation.projectionLoc = [self uniformLocation:@"aProjection"];
    mLocation.alphaLoc      = [self uniformLocation:@"uAlpha"];
    mLocation.colorLoc      = [self uniformLocation:@"uColor"];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        [self setMode:kPBProgramModeManual];
        [self setDelegate:self];
        [self linkVertexShaderFilename:@"Glowline" fragmentShaderFilename:@"Glowline"];
        [self bindLocation];

        mColor            = [[PBColor colorWithRed:0.9647 green:0.3347 blue:0.7f alpha:1.0f] retain];
        
        mVerticesQueue    = calloc(kMaxLines * kMeshVertexSize, sizeof(GLfloat));
        mCoordinatesQueue = calloc(kMaxLines * kMeshCoordinateSize, sizeof(GLfloat));
        mIndicesQueue     = calloc(kMaxLines * sizeof(gIndices) / sizeof(gIndices[0]), sizeof(GLushort));
        PBInitIndicesQueue(mIndicesQueue, kMaxLines * sizeof(gIndices) / sizeof(gIndices[0]), sizeof(gIndices) / sizeof(gIndices[0]));
    }
    
    return self;
}


- (void)dealloc
{
    if (mVerticesQueue)
    {
        free(mVerticesQueue);
    }
    
    if (mCoordinatesQueue)
    {
        free(mCoordinatesQueue);
    }
    
    if (mIndicesQueue)
    {
        free(mIndicesQueue);
    }
    
    [mColor release];
    [mCamera release];
    
    [super dealloc];
}


#pragma mark -


- (void)fire
{
    mFire        = YES;
    mAlpha       = kFlashAlpha;
    mDrawLines   = 0;
    
    mBaseAngle = PBRadiansToDegrees(-atan2f(mEndPoint.y - mStartPoint.y, mEndPoint.x - mStartPoint.x));
    [self generatorLaserWithStartPoint:mStartPoint endPoint:mEndPoint];
//    [self generatorLaserWithStartPoint:mStartPoint endPoint:mEndPoint];
}


- (void)stop
{
    mFire = NO;
}


- (void)setCamera:(PBCamera *)aCamera
{
    [mCamera autorelease];
    mCamera = [aCamera retain];
}


- (void)pbProgramWillManualDraw:(PBProgram *)aProgram
{
    if (!mFire)
    {
        return;
    }

    if (mAlpha < 0.0)
    {
        [self stop];
    }
    
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);

    PBMatrix sProjection = [mCamera projection];
    glUniformMatrix4fv(mLocation.projectionLoc, 1, 0, &sProjection.m[0]);
    
    glUniform1f(mLocation.alphaLoc, mAlpha);
    glUniform3f(mLocation.colorLoc, mColor.r, mColor.g, mColor.b);

    glVertexAttribPointer(mLocation.positionLoc, 3, GL_FLOAT, GL_FALSE, 0, mVerticesQueue);
    glEnableVertexAttribArray(mLocation.positionLoc);

    glVertexAttribPointer(mLocation.CoordinateLoc, 2, GL_FLOAT, GL_FALSE, 0, mCoordinatesQueue);
    glEnableVertexAttribArray(mLocation.CoordinateLoc);

    mDrawLines += kMaxLines / 4;
    if (kMaxLines < mDrawLines)
    {
        mDrawLines = kMaxLines;
    }
    
    glDrawElements(GL_TRIANGLES, mDrawLines * sizeof(gIndices) / sizeof(gIndices[0]), GL_UNSIGNED_SHORT, mIndicesQueue);
    
    glDisableVertexAttribArray(mLocation.positionLoc);
    glDisableVertexAttribArray(mLocation.CoordinateLoc);
    
    mAlpha -= 0.05;
}


@end