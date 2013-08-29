/*
 *  PBTileNode.m
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 29..
 *  Copyright (c) 2013 NHN. All rights reserved.
 *
 */

#import "PBTileNode.h"
#import "PBTileMesh.h"
#import "PBNodePrivate.h"


@implementation PBTileNode
{
    NSUInteger mTileIndex;
}


#pragma mark -


+ (Class)meshClass
{
    return [PBTileMesh class];
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
    [(PBTileMesh *)[self mesh] setTileSize:aTileSize];
    [(PBTileMesh *)[self mesh] updateCoordinatesWithIndex:mTileIndex];
}


- (CGSize)tileSize
{
    return [(PBTileMesh *)[self mesh] tileSize];
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
    return [(PBTileMesh *)[self mesh] count];
}


- (void)selectTileAtIndex:(NSInteger)aIndex
{
    if ([self tileIndex] != aIndex)
    {
        [self setTileIndex:aIndex];
        [(PBTileMesh *)[self mesh] selectTileAtIndex:aIndex];
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
