/*
 *  Map.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 2. 19..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "Map.h"


@implementation Map
{
    CGSize          mMapSize;
    CGSize          mTileSize;
    CGRect          mBounds;
    PBTexture      *mTexture;
    NSArray        *mIndexArray;
 
    NSMutableArray *mVisibleTiles;
    NSMutableArray *mTilePool;
}


@synthesize mapSize  = mMapSize;
@synthesize tileSize = mTileSize;


#pragma mark -


- (CGPoint)positionFromGridPosition:(CGPoint)aGridPosition
{
    return CGPointMake((aGridPosition.x * mTileSize.width) + (mTileSize.width / 2),
                       mBounds.size.height - (aGridPosition.y * mTileSize.height) - (mTileSize.height / 2));
}


- (NSInteger)tileIndexOfGridPosition:(CGPoint)aPoint
{
    NSInteger sResult = -1;
    
    if (aPoint.x >= 0 && aPoint.y >= 0 && aPoint.x < mMapSize.width && aPoint.y < mMapSize.height)
    {
        sResult = [[mIndexArray objectAtIndex:(aPoint.y * mMapSize.width + aPoint.x)] integerValue] - 1;
    }
    
    return sResult;
}


- (NSInteger)tileIndexAtPoint:(CGPoint)aPoint
{
    NSInteger sResult = -1;
    
    if (aPoint.x >= 0 && aPoint.x < mBounds.size.width && aPoint.y >= 0 && aPoint.y < mBounds.size.height)
    {
        NSInteger sXIndex = floorf(aPoint.x / mTileSize.width);
        NSInteger sYIndex = (mMapSize.height - 1) - floorf(aPoint.y / mTileSize.height);
        
        sResult = [self tileIndexOfGridPosition:CGPointMake(sXIndex, sYIndex)];
    }
    
    return sResult;
}


- (PBTileSprite *)unusedTile
{
    PBTileSprite *sTile = nil;
    
    if ([mTilePool count])
    {
        sTile = [[mTilePool lastObject] retain];
        [mTilePool removeLastObject];
    }
    else
    {
        sTile = [[PBTileSprite alloc] initWithTexture:mTexture tileSize:mTileSize];
        [sTile setHidden:YES];
        [self addSubNode:sTile];
    }
    
    return [sTile autorelease];
}


#pragma mark -


- (id)initWithMapSize:(CGSize)aSize tileImage:(UIImage *)aImage tileSize:(CGSize)aTileSize indexArray:(NSArray *)aIndexArray
{
    self = [super init];
    
    if (self)
    {
        mMapSize     = aSize;
        mTileSize    = aTileSize;
        mBounds      = CGRectMake(0, 0, mMapSize.width * mTileSize.width, mMapSize.height * mTileSize.height);
        mIndexArray  = [aIndexArray retain];
        mTexture     = [[PBTexture alloc] initWithImage:aImage];
        [mTexture loadIfNeeded];
        
        mVisibleTiles = [[NSMutableArray alloc] init];
        mTilePool     = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mIndexArray release];
    [mTexture release];
    [mVisibleTiles release];
    [mTilePool release];
    
    [super dealloc];
}


- (CGRect)bounds
{
    return mBounds;
}


- (void)setVisibleRect:(CGRect)aRect
{
//    double sCurrentTime = CACurrentMediaTime();
    CGRect sRect        = aRect;
    
    CGFloat sXLeft = fmodf(aRect.origin.x, mTileSize.width);
    CGFloat sYLeft = fmodf(aRect.origin.y, mTileSize.height);
    
    if (sRect.origin.x < 0)
    {
        sXLeft = aRect.origin.x;
        sRect.origin.x = 0;
    }
    
    if (aRect.origin.y < 0)
    {
        sYLeft = aRect.origin.y;
        sRect.origin.y = 0;
    }
    
    [mTilePool addObjectsFromArray:mVisibleTiles];
    for (PBTileSprite *sTile in mVisibleTiles)
    {
        [sTile setHidden:YES];
    }
    [mVisibleTiles removeAllObjects];
    
    for (CGFloat y = sRect.origin.y; y < (sRect.origin.y + sRect.size.height + mTileSize.height); y += mTileSize.height)
    {
        for (CGFloat x = sRect.origin.x; x < (sRect.origin.x + sRect.size.width + mTileSize.width); x += mTileSize.width)
        {
            NSInteger sIndex = [self tileIndexAtPoint:CGPointMake(x, y)];
            if (sIndex >= 0)
            {
                PBTileSprite *sTile = [self unusedTile];
                [sTile selectSpriteAtIndex:sIndex];
                [sTile setPoint:CGPointMake(x - sRect.origin.x + mTileSize.width / 2 - sXLeft, y - sRect.origin.y + mTileSize.height / 2 - sYLeft)];
                [sTile setHidden:NO];
                [mVisibleTiles addObject:sTile];
            }
        }
    }
    
//    sCurrentTime =  CACurrentMediaTime() - sCurrentTime;
//    NSLog(@"%f", sCurrentTime);
}


@end
