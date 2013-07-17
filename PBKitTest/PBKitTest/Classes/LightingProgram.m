/*
 *  LightingProgram.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 11..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBKit.h>
#import <PBVertices.h>
#import "LightingProgram.h"


#define kMaxJaggedLines 1000
#define kFlashAlpha     0.9
#define kMaxBranchCount 20


typedef struct {
    GLint projectionLoc;
    GLint positionLoc;
    GLint CoordinateLoc;
    GLint resolutionLoc;
    GLint timeLoc;
    GLint alphaLoc;
    GLint colorLoc;
    
} LightningLocation;


@implementation LightingProgram
{
    LightningLocation mLocation;
    PBCamera         *mCamera;
    GLfloat           mAlpha;
    
    GLfloat          *mVerticesQueue;
    GLfloat          *mCoordinatesQueue;
    GLushort         *mIndicesQueue;
    
    GLint             mJaggedLines;
    GLint             mDrawLines;
    
    PBColor          *mColor;
    CGPoint           mStartPoint;
    CGPoint           mEndPoint;
    CGFloat           mBaseAngle;
    BOOL              mFire;
    GLint             mBranchCount;
}


@synthesize startPoint = mStartPoint;
@synthesize endPoint   = mEndPoint;
@synthesize color      = mColor;


#pragma mark -


- (void)generatorLightningWithStartPoint:(CGPoint)aStartPoint
                                endPoint:(CGPoint)aEndPoint
                                isBranch:(BOOL)aIsBranch
{
    CGPoint sBeforePoint  = aStartPoint;
    GLint   sJaggedLines  = sqrtf(powf(aEndPoint.x - aStartPoint.x, 2) + powf(aEndPoint.y - aStartPoint.y, 2)) / 3.0f;
    BOOL    sForceCutLine = NO;
    
    if ((mJaggedLines + sJaggedLines) > kMaxJaggedLines)
    {
        NSLog(@"Jaggedlines count = %d", mJaggedLines);
        NSAssert(NO, @"Exception occured overflow jaggedlines for lightning effect.");
        return;
    }
    
    for (NSInteger i = 0; i < sJaggedLines; i++)
    {
        GLfloat sVertices[kMeshVertexSize];
        GLfloat sLength      = (arc4random() % 3) + 1;
        GLfloat sThickness   = ((arc4random() % 5) + (sJaggedLines - i)) / 2;
        CGSize  sVerticeSize = CGSizeMake(sLength, sThickness);
        GLfloat sAngle       = ((GLfloat)(arc4random() % 100) / 2.0f) * ((GLfloat)((arc4random() % 2) == 0) ? 1.0 : -1.0);
        sAngle              += mBaseAngle;
        BOOL    sIsLastLine  = (i == (sJaggedLines - 1) && !aIsBranch) ? YES : NO;
        
        PBMakeMeshVertiesMakeFromSize(sVertices, sVerticeSize.width, sVerticeSize.height, 0.0f);
        PBRotateMeshVertice(sVertices, sAngle);

        if (i == 0)
        {
            CGPoint sOffset;
            sOffset.x = sBeforePoint.x + (sVertices[6] + sVertices[9]) / 2;
            sOffset.y = sBeforePoint.y + (sVertices[7] + sVertices[10]) / 2;
            PBMakeMeshVertice(sVertices, sVertices, sOffset.x, sOffset.y, 0);
        }
        else
        {
            if (sIsLastLine || sForceCutLine)
            {
                CGFloat sDistance = sqrtf(powf(aEndPoint.x - sBeforePoint.x, 2) + powf(aEndPoint.y - sBeforePoint.y, 2));
                sAngle = PBRadiansToDegrees(-atan2f(aEndPoint.y - sBeforePoint.y, aEndPoint.x - sBeforePoint.x));
                PBMakeMeshVertiesMakeFromSize(sVertices, sDistance / 2, sVerticeSize.height, 0.0f);
                PBRotateMeshVertice(sVertices, sAngle);
            }
            else
            {
                if (mBranchCount < kMaxBranchCount)
                {
                    BOOL sBranchLine = ((arc4random() % 5) == 0) ? YES : NO;
                    if (sBranchLine)
                    {
                        CGFloat sDistance = sqrtf(powf(aEndPoint.x - sBeforePoint.x, 2) + powf(aEndPoint.y - sBeforePoint.y, 2));
                        GLfloat sBranchLength = (arc4random() % (GLint)(sDistance * 0.8)) + 10;
                        
                        CGPoint sBranchPoint  = CGPointMake(((-sBranchLength + -sBranchLength) / 2) + sBeforePoint.x, sBeforePoint.y);
                        [self generatorLightningWithStartPoint:sBeforePoint endPoint:sBranchPoint isBranch:YES];
                    }
                }
            }

            if (aIsBranch)
            {
                mBranchCount++;
            }

            CGPoint sPoint  = CGPointMake((sVertices[0] + sVertices[3]) / 2, (sVertices[1] + sVertices[4]) / 2);
            CGPoint sOffset = CGPointMake(sBeforePoint.x - sPoint.x, sBeforePoint.y - sPoint.y);
            PBMakeMeshVertice(sVertices, sVertices, sOffset.x, sOffset.y, 0);
        }
        
        sBeforePoint.x = (sVertices[6] + sVertices[9]) / 2;
        sBeforePoint.y = (sVertices[7] + sVertices[10]) / 2;
        
        memcpy(&mVerticesQueue[mJaggedLines * kMeshVertexSize], sVertices, kMeshVertexSize * sizeof(GLfloat));
        memcpy(&mCoordinatesQueue[mJaggedLines * kMeshCoordinateSize], gTexCoordinates, kMeshCoordinateSize * sizeof(GLfloat));
        mJaggedLines++;
        
        if (sForceCutLine)
        {
            break;
        }
        
        if (!aIsBranch && (sqrtf(powf(aEndPoint.x - sBeforePoint.x, 2) + powf(aEndPoint.y - sBeforePoint.y, 2)) < 30))
        {
            sForceCutLine = YES;
        }
    }
}


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

        mColor            = [[PBColor colorWithRed:0.3f green:0.3347 blue:0.9647 alpha:1.0f] retain];
        mBranchCount      = kMaxBranchCount;
        
        mVerticesQueue    = calloc(kMaxJaggedLines * kMeshVertexSize, sizeof(GLfloat));
        mCoordinatesQueue = calloc(kMaxJaggedLines * kMeshCoordinateSize, sizeof(GLfloat));
        mIndicesQueue     = calloc(kMaxJaggedLines * sizeof(gIndices) / sizeof(gIndices[0]), sizeof(GLushort));
        PBInitIndicesQueue(mIndicesQueue, kMaxJaggedLines * sizeof(gIndices) / sizeof(gIndices[0]), sizeof(gIndices) / sizeof(gIndices[0]));
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
    mJaggedLines = 0;
    mBranchCount = 0;
    
    mBaseAngle = PBRadiansToDegrees(-atan2f(mEndPoint.y - mStartPoint.y, mEndPoint.x - mStartPoint.x));
    [self generatorLightningWithStartPoint:mStartPoint endPoint:mEndPoint isBranch:NO];
    NSLog(@"jaged line = %d, branch line = %d", mJaggedLines, mBranchCount);
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

    mDrawLines += mJaggedLines / 4;
    if (mJaggedLines < mDrawLines)
    {
        mDrawLines = mJaggedLines;
    }
    
    glDrawElements(GL_TRIANGLES, mDrawLines * sizeof(gIndices) / sizeof(gIndices[0]), GL_UNSIGNED_SHORT, mIndicesQueue);
    
    glDisableVertexAttribArray(mLocation.positionLoc);
    glDisableVertexAttribArray(mLocation.CoordinateLoc);
    
    mAlpha -= 0.05;
}


@end