/*
 *  PBTileNode.m
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 29..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTileNode.h"
#import "PBMutableMesh.h"
#import "PBNodePrivate.h"


@implementation PBTileNode
{
    CGSize     mTileSize;

    NSUInteger mColCount;
    NSUInteger mRowCount;
    NSUInteger mTileCount;
    
    NSUInteger mTileIndex;
    CGRect     mCurrentRect;
}


#pragma mark -


+ (Class)meshClass
{
    return [PBMutableMesh class];
}


#pragma mark -


- (id)initWithImageNamed:(NSString *)aName tileSize:(CGSize)aTileSize
{
    self = [super initWithImageNamed:aName];
    
    if (self)
    {
        mTileIndex = 0;
        [self setTileSize:aTileSize];
    }
    
    return self;
}


- (id)initWithTexture:(PBTexture *)aTexture tileSize:(CGSize)aTileSize
{
    self = [super initWithTexture:aTexture];
    
    if (self)
    {
        mTileIndex = 0;
        [self setTileSize:aTileSize];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)setCoordinateMode:(PBCoordinateMode)aMode
{
    [super setCoordinateMode:aMode];
    [self setTileIndex:-1];
}


#pragma mark -


- (void)setTileSize:(CGSize)aTileSize
{
    mTileSize = aTileSize;
    
    if ([self texture])
    {
        CGSize sTextureSize = [[self texture] size];

        mColCount    = sTextureSize.width / mTileSize.width;
        mRowCount    = sTextureSize.height / mTileSize.height;
        mTileCount   = mColCount * mRowCount;

        [self selectTileAtIndex:0];
    }
}


- (CGSize)tileSize
{
    return mTileSize;
}


- (void)setTileIndex:(NSUInteger)aTileIndex
{
    mTileIndex = aTileIndex;
}


- (NSUInteger)tileIndex
{
    return mTileIndex;
}


#pragma mark -


- (NSInteger)tileCount
{
    return mTileCount;
}


- (void)selectTileAtIndex:(NSInteger)aIndex
{
    if (mTileIndex == 0 || mTileIndex != aIndex)
    {
        mTileIndex = aIndex;

        NSInteger x = fmodf((float)mTileIndex, (float)mColCount);
        NSInteger y = (mTileIndex == 0) ? 0 : aIndex / mColCount;
        
        mCurrentRect = CGRectMake(mTileSize.width * x, mTileSize.height * y, mTileSize.width, mTileSize.height);

        PBMutableMesh *sMesh = (PBMutableMesh *)[self mesh];
        [sMesh setCoordinateRect:mCurrentRect];
    }
}


- (BOOL)selectNextTile
{
    BOOL      sResult = NO;
    NSInteger sIndex = [self tileIndex] + 1;
    
    if (sIndex >= [self tileCount])
    {
        sIndex = 0;
        sResult = YES;
    }
    
    [self selectTileAtIndex:sIndex];
    
    return sResult;
}


- (BOOL)selectPreviousTile
{
    BOOL       sResult = NO;
    NSUInteger sTileIndex = [self tileIndex];
    
    if (sTileIndex == 0)
    {
        [self setTileIndex:([self tileCount] - 1)];
        sResult = YES;
    }
    else
    {
        [self setTileIndex:(sTileIndex - 1)];
        [self selectTileAtIndex:[self tileIndex]];
    }
    
    return sResult;
}


@end
