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
    CGRect mCoordRect;
}


- (void)updateVertices
{
    CGSize sSize = [[self texture] size];
    
    mVertices[0] = -(sSize.width / 2);
    mVertices[1] = (sSize.height / 2);
    mVertices[2] = [self zPoint];
    mVertices[3] = -(sSize.width / 2);
    mVertices[4] = -(sSize.height / 2);
    mVertices[5] = [self zPoint];
    mVertices[6] = (sSize.width / 2);
    mVertices[7] = -(sSize.height / 2);
    mVertices[8] = [self zPoint];
    mVertices[9] = (sSize.width / 2);
    mVertices[10] = (sSize.height / 2);
    mVertices[11] = [self zPoint];
}


- (void)updateCoordinates
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


- (void)setCoordinateRect:(CGRect)aRect
{
    CGSize sSize = [[self texture] size];
    
    mCoordRect = CGRectMake(aRect.origin.x / sSize.width, aRect.origin.y / sSize.height, aRect.size.width / sSize.width, aRect.size.height / sSize.height);
    
    [self updateVertices];
    [self updateCoordinates];
}


@end
