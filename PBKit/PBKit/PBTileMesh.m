/*
 *  PBTileMesh.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 28..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTileMesh.h"
#import "PBTexture.h"


@interface PBMesh (Privates)

- (void)setupVertices;
- (void)setupCoordinates;

@end


@implementation PBTileMesh
{
    CGSize          mTileSize;
    CGSize          mTileCoord;
    NSInteger       mColCount;
    NSInteger       mRowCount;
    NSInteger       mIndex;
}


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mIndex = -1;
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)setupVertices
{
    mVertices[0] = -(mTileSize.width / 2);
    mVertices[1] = (mTileSize.height / 2);
    mVertices[2] = [self zPoint];
    mVertices[3] = -(mTileSize.width / 2);
    mVertices[4] = -(mTileSize.height / 2);
    mVertices[5] = [self zPoint];
    mVertices[6] = (mTileSize.width / 2);
    mVertices[7] = -(mTileSize.height / 2);
    mVertices[8] = [self zPoint];
    mVertices[9] = (mTileSize.width / 2);
    mVertices[10] = (mTileSize.height / 2);
    mVertices[11] = [self zPoint];
}


- (void)updateTileData
{
    if ([self texture])
    {
        CGSize sSize = [[self texture] size];
        
        mTileCoord = CGSizeMake(mTileSize.width / sSize.width, mTileSize.height / sSize.height);;
        mColCount  = sSize.width / mTileSize.width;
        mRowCount  = sSize.height / mTileSize.height;

#if (0)
        NSLog(@"mTileCoord = %@", NSStringFromCGSize(mTileCoord));
        NSLog(@"mColCount  = %d", mColCount);
        NSLog(@"mRowCount  = %d", mRowCount);
#endif
    }
}

- (void)setTexture:(PBTexture *)aTexture
{
    NSAssert((mTileSize.width > 0 && mTileSize.height > 0), @"Must set TileSize before setTexture.");

    [super setTexture:aTexture];
    [self updateTileData];
    [self selectTileAtIndex:0];
}


- (CGSize)size
{
    return mTileSize;
}


#pragma mark -


- (void)updateCoordinatesWithIndex:(NSInteger)aIndex
{
    NSInteger y = (aIndex == 0) ? 0 : aIndex / mColCount;
    NSInteger x = fmodf((float)aIndex, (float)mColCount);
    
    mCoordinates[0] = mTileCoord.width * x;
    mCoordinates[1] = mTileCoord.height * y;
    mCoordinates[2] = mCoordinates[0];
    mCoordinates[3] = mCoordinates[1] + mTileCoord.height;
    mCoordinates[4] = mCoordinates[0] + mTileCoord.width;
    mCoordinates[5] = mCoordinates[1] + mTileCoord.height;
    mCoordinates[6] = mCoordinates[0] + mTileCoord.width;
    mCoordinates[7] = mCoordinates[1];
}


- (void)setTileSize:(CGSize)aTileSize
{
    mTileSize = aTileSize;
    
    [self updateTileData];
    [self setupVertices];
}


- (CGSize)tileSize
{
    return mTileSize;
}


- (NSInteger)count
{
    return mColCount * mRowCount;
}


- (void)selectTileAtIndex:(NSInteger)aIndex
{
    mIndex = aIndex;

    if ([self meshRenderOption] == kPBMeshRenderOptionDefault || [self meshRenderOption] == kPBMeshRenderOptionImmediately)
    {
        [self updateCoordinatesWithIndex:mIndex];
    }
}


@end
