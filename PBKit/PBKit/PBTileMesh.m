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
#import "PBKit.h"


@interface PBMesh (Privates)

- (void)setupVertices;
- (void)setupCoordinates;
- (void)setupMeshKey;
- (void)setupMeshArray;

@end


@implementation PBTileMesh
{
    CGSize          mTileSize;
    CGSize          mTileCoord;
    NSInteger       mColCount;
    NSInteger       mRowCount;
    NSInteger       mIndex;
    
    NSMutableArray *mMeshArrays;
}


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mIndex      = -1;
        mMeshArrays = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mMeshArrays release];
    
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
    
    mMeshData[0].vertex[0] = mVertices[0];
    mMeshData[0].vertex[1] = mVertices[1];
    mMeshData[0].vertex[2] = mVertices[2];
    mMeshData[1].vertex[0] = mVertices[3];
    mMeshData[1].vertex[1] = mVertices[4];
    mMeshData[1].vertex[2] = mVertices[5];
    mMeshData[2].vertex[0] = mVertices[6];
    mMeshData[2].vertex[1] = mVertices[7];
    mMeshData[2].vertex[2] = mVertices[8];
    mMeshData[3].vertex[0] = mVertices[9];
    mMeshData[3].vertex[1] = mVertices[10];
    mMeshData[3].vertex[2] = mVertices[11];
}


- (void)setTexture:(PBTexture *)aTexture
{
    CGSize sSize = [aTexture size];
    
    mTileCoord = CGSizeMake(mTileSize.width / sSize.width, mTileSize.height / sSize.height);;
    mColCount  = sSize.width / mTileSize.width;
    mRowCount  = sSize.height / mTileSize.height;
    
//    NSLog(@"mTileCoord = %@", NSStringFromCGSize(mTileCoord));
//    NSLog(@"mColCount  = %d", mColCount);
//    NSLog(@"mRowCount  = %d", mRowCount);
    
    [super setTexture:aTexture];

    /*  MeshArray cache  */
    [mMeshArrays removeAllObjects];
    
    for (NSInteger i = 0; i < [self count]; i++)
    {
        [self setupCoordinatesWithIndex:i];
        [self setupMeshKey];
        [self setupMeshArray];
        [mMeshArrays addObject:[self meshArray]];
    }
    
    [self selectTileAtIndex:0];
}


- (CGSize)size
{
    return mTileSize;
}


#pragma mark -


- (void)setupCoordinatesWithIndex:(NSInteger)aIndex
{
    NSInteger y = (aIndex == 0) ? 0 : aIndex / mColCount;
    NSInteger x = fmodf((float)aIndex, (float)mColCount);

#if (1)
    mCoordinates[0] = mTileCoord.width * x;
    mCoordinates[1] = mTileCoord.height * y;
    mCoordinates[2] = mCoordinates[0];
    mCoordinates[3] = mCoordinates[1] + mTileCoord.height;
    mCoordinates[4] = mCoordinates[0] + mTileCoord.width;
    mCoordinates[5] = mCoordinates[1] + mTileCoord.height;
    mCoordinates[6] = mCoordinates[0] + mTileCoord.width;
    mCoordinates[7] = mCoordinates[1];
    
    mMeshData[0].coordinates[0] = mCoordinates[0];
    mMeshData[0].coordinates[1] = mCoordinates[1];
    mMeshData[1].coordinates[0] = mCoordinates[2];
    mMeshData[1].coordinates[1] = mCoordinates[3];
    mMeshData[2].coordinates[0] = mCoordinates[4];
    mMeshData[2].coordinates[1] = mCoordinates[5];
    mMeshData[3].coordinates[0] = mCoordinates[6];
    mMeshData[3].coordinates[1] = mCoordinates[7];
#else
    mMeshData[0].coordinates[0] = mTileCoord.width * x;
    mMeshData[0].coordinates[1] = mTileCoord.height * y;
    mMeshData[1].coordinates[0] = mMeshData[0].coordinates[0];
    mMeshData[1].coordinates[1] = mMeshData[0].coordinates[1] + mTileCoord.height;
    mMeshData[2].coordinates[0] = mMeshData[0].coordinates[0] + mTileCoord.width;
    mMeshData[2].coordinates[1] = mMeshData[0].coordinates[1] + mTileCoord.height;
    mMeshData[3].coordinates[0] = mMeshData[0].coordinates[0] + mTileCoord.width;
    mMeshData[3].coordinates[1] = mMeshData[0].coordinates[1];
#endif
}


#pragma mark -


- (void)setTileSize:(CGSize)aTileSize
{
    mTileSize = aTileSize;
    
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
    if (mIndex != aIndex)
    {
        mIndex = aIndex;
        switch ([self meshRenderOption])
        {
            case kPBMeshRenderOptionUsingMesh:
                [self setMeshArray:[mMeshArrays objectAtIndex:mIndex]];
                break;
            case kPBMeshRenderOptionUsingMeshQueue:
                [self setupCoordinatesWithIndex:mIndex];
                break;
            case kPBMeshRenderOptionUsingCallback:
                break;
            default:
                break;
        }
    }
}


@end
    