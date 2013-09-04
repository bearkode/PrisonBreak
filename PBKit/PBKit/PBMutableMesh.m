/*
 *  PBMutableMesh.m
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 29..
 *  Copyright (c) 2013 NHN. All rights reserved.
 *
 */

#import "PBMutableMesh.h"


@implementation PBMutableMesh
{
    CGRect mCurrentRect;
    CGRect mCoordRect;
}


#pragma mark -


- (void)setCoordinateMode:(PBMeshCoordinateMode)aMode
{
    [super setCoordinateMode:aMode];
    
    [self updateVertices];
    [self updateCoordinates];
}


- (void)updateVertices
{
    mVertices[0] = -(mCurrentRect.size.width / 2);
    mVertices[1] = (mCurrentRect.size.height / 2);
    mVertices[2] = [self zPoint];
    mVertices[3] = -(mCurrentRect.size.width / 2);
    mVertices[4] = -(mCurrentRect.size.height / 2);
    mVertices[5] = [self zPoint];
    mVertices[6] = (mCurrentRect.size.width / 2);
    mVertices[7] = -(mCurrentRect.size.height / 2);
    mVertices[8] = [self zPoint];
    mVertices[9] = (mCurrentRect.size.width / 2);
    mVertices[10] = (mCurrentRect.size.height / 2);
    mVertices[11] = [self zPoint];
}


#pragma mark -


- (void)updateMeshData
{
    [self updateVertices];
}


- (void)updateCoordinates
{
    if ([self coordinateMode] == kPBMeshCoordinateNormal)
    {
        mCoordinates[0] = mCoordRect.origin.x;
        mCoordinates[1] = mCoordRect.origin.y;
        mCoordinates[2] = mCoordinates[0];
        mCoordinates[3] = mCoordinates[1] + mCoordRect.size.height;
        mCoordinates[4] = mCoordinates[0] + mCoordRect.size.width;
        mCoordinates[5] = mCoordinates[1] + mCoordRect.size.height;
        mCoordinates[6] = mCoordinates[0] + mCoordRect.size.width;
        mCoordinates[7] = mCoordinates[1];
    }
    else if ([self coordinateMode] == kPBMeshCoordinateFlipHorizontal)
    {
        mCoordinates[0] = mCoordRect.origin.x + mCoordRect.size.width;
        mCoordinates[1] = mCoordRect.origin.y;
        mCoordinates[2] = mCoordinates[0];
        mCoordinates[3] = mCoordinates[1] + mCoordRect.size.height;
        mCoordinates[4] = mCoordinates[0] - mCoordRect.size.width;
        mCoordinates[5] = mCoordinates[1] + mCoordRect.size.height;
        mCoordinates[6] = mCoordinates[0] - mCoordRect.size.width;
        mCoordinates[7] = mCoordinates[1];
    }
    else if ([self coordinateMode] == kPBMeshCoordinateFlipVertical)
    {
        mCoordinates[0] = mCoordRect.origin.x;
        mCoordinates[1] = mCoordRect.origin.y + mCoordRect.size.height;
        mCoordinates[2] = mCoordinates[0];
        mCoordinates[3] = mCoordinates[1] - mCoordRect.size.height;
        mCoordinates[4] = mCoordinates[0] + mCoordRect.size.width;
        mCoordinates[5] = mCoordinates[1] - mCoordRect.size.height;
        mCoordinates[6] = mCoordinates[0] + mCoordRect.size.width;
        mCoordinates[7] = mCoordinates[1];
    }
}


- (void)setCoordinateRect:(CGRect)aRect
{
    CGSize sSize = [self vertexSize];
    
    mCurrentRect = aRect;
    mCoordRect   = CGRectMake(aRect.origin.x / sSize.width, aRect.origin.y / sSize.height, aRect.size.width / sSize.width, aRect.size.height / sSize.height);
    
    [self updateVertices];
    [self updateCoordinates];
}


@end
