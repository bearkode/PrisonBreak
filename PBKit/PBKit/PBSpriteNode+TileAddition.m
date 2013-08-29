/*
 *  PBSpriteNode+TileAddition.m
 *  PBKit
 *
 *  Created by bearkode on 13. 6. 26..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBSpriteNode+TileAddition.h"
#import "PBTileMesh.h"
#import "PBNodePrivate.h"


@implementation PBSpriteNode (TileAddition)


#pragma mark -


- (void)setTileSize:(CGSize)aTileSize
{
//    PBTileMesh *sMesh = [[[PBTileMesh alloc] init] autorelease];
//    [sMesh setTexture:[self texture]];
//    [self setMesh:sMesh];
    
    [(PBTileMesh *)[self mesh] setTileSize:aTileSize];
    [(PBTileMesh *)[self mesh] updateCoordinatesWithIndex:0];
}


- (CGSize)tileSize
{
    return [(PBTileMesh *)[self mesh] tileSize];
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
