/*
 *  Explosion.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 2. 13..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "Explosion.h"


@implementation Explosion
{
    NSInteger mTileIndex;
    NSInteger mTileColumnIndex;
    NSInteger mTileRowIndex;
    NSInteger mAnimateSpriteCounts;
}


- (id)init
{
    self = [super init];
    
    if (self)
    {
        PBTexture *sTexture = [[[PBTexture alloc] initWithImageName:@"exp1"] autorelease];
        [self setTexture:sTexture];
        
        [self setTileSize:CGSizeMake(64, 64)];
        
        mTileIndex = -1;
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


- (void)setTileSize:(CGSize)aTileSize
{
    mTileIndex = -1;
    [(PBTileMesh *)[self mesh] setTileSize:aTileSize];
}


- (void)setAnimationSpriteCount:(NSInteger)aCount
{
    mAnimateSpriteCounts = aCount;
}


- (void)selectTileAtIndex:(NSInteger)aIndex
{
    mTileIndex = aIndex;
    [(PBTileMesh *)[self mesh] selectTileAtIndex:aIndex];
}


- (void)animateTile
{
    if (mTileRowIndex >= mAnimateSpriteCounts)
    {
        mTileRowIndex = 0;
    }
    
    [self selectTileAtIndex:mTileColumnIndex + mTileRowIndex];
    mTileRowIndex++;
}


- (BOOL)update
{
    [self animateTile];
    
    return YES;
}


@end
