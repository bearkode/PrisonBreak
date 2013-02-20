/*
 *  Map.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 2. 19..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "Map.h"


#define USE_TILE_POOL   1


@implementation Map
{
    CGSize          mMapSize;
    CGSize          mTileSize;
    CGRect          mBounds;
    PBTextureInfo  *mTextureInfo;
    NSArray        *mIndexArray;
 
#if (USE_TILE_POOL)
    NSMutableArray *mVisibleTiles;
    NSMutableArray *mTilePool;
#else
    NSMutableArray *mMapTiles;
#endif
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
        
//        NSLog(@"sXIndex = %d, sYIndex = %d", sXIndex, sYIndex);

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
        sTile = [[PBTileSprite alloc] initWithTextureInfo:mTextureInfo tileSize:mTileSize];
    }
    
    return [sTile autorelease];
}


#if (USE_TILE_POOL)
#else
- (void)setupMapTiles
{
    for (NSInteger x = 0; x < mMapSize.width; x++)
    {
        for (NSInteger y = 0; y < mMapSize.height; y++)
        {
            PBTileSprite *sMapTile   = [[PBTileSprite alloc] initWithTextureInfo:mTextureInfo tileSize:mTileSize];
            NSInteger     sTileIndex = [[mIndexArray objectAtIndex:y * mMapSize.width + x] integerValue] - 1;
            
            [mMapTiles addObject:sMapTile];
            [self addSubrenderable:sMapTile];
            
            [sMapTile setPosition:[self positionFromGridPosition:CGPointMake(x, y)]];
            [sMapTile selectSpriteAtIndex:sTileIndex];
            
            [sMapTile release];
        }
    }
}
#endif


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
        mTextureInfo = [[PBTextureInfo alloc] initWithImage:aImage];
        [mTextureInfo loadIfNeeded];
        
#if (USE_TILE_POOL)
        mVisibleTiles = [[NSMutableArray alloc] init];
        mTilePool     = [[NSMutableArray alloc] init];
#else
        mMapTiles    = [[NSMutableArray alloc] init];
        [self setupMapTiles];
#endif

#if (0)
        [self setProgram:[[PBProgramManager sharedManager] bundleProgram]];
        PBTextureInfo *sTextureInfo = [PBTextureInfoManager textureInfoWithImageName:@"coin.png"];
        PBTexture     *sTexture     = [[PBTexture alloc] initWithTextureInfo:sTextureInfo];
        [sTextureInfo loadIfNeeded];
        [self setTexture:sTexture];
        [sTexture release];
#endif
    }
    
    return self;
}


- (void)dealloc
{
    [mIndexArray release];
    [mTextureInfo release];
    
#if (USE_TILE_POOL)
    [mVisibleTiles release];
    [mTilePool release];
#else
    [mMapTiles release];
#endif
    
    [super dealloc];
}


- (CGRect)bounds
{
    return mBounds;
}


- (void)setVisibleRect:(CGRect)aRect
{
#if (USE_TILE_POOL)
    CGFloat sXLeft = fmodf(aRect.origin.x, 32);
    CGFloat sYLeft = fmodf(aRect.origin.y, 32);

    if (aRect.origin.x < 0)
    {
        sXLeft = aRect.origin.x;
        aRect.origin.x = 0;
    }
    
    if (aRect.origin.y < 0)
    {
        sYLeft = aRect.origin.y;
        aRect.origin.y = 0;
    }
    
    for (PBTileSprite *sTile in mVisibleTiles)
    {
        [mTilePool addObject:sTile];
        [sTile removeFromSuperrenderable];
    }
    [mVisibleTiles removeAllObjects];

    for (CGFloat y = aRect.origin.y; y < (aRect.origin.y + aRect.size.height + mTileSize.height); y += mTileSize.height)
    {
        for (CGFloat x = aRect.origin.x; x < (aRect.origin.x + aRect.size.width + mTileSize.width); x += mTileSize.width)
        {
            NSInteger sIndex = [self tileIndexAtPoint:CGPointMake(x, y)];
            if (sIndex >= 0)
            {
                PBTileSprite *sTile = [self unusedTile];
                [sTile selectSpriteAtIndex:sIndex];
                [sTile setPosition:CGPointMake(x - aRect.origin.x + mTileSize.width / 2 - sXLeft, y - aRect.origin.y + mTileSize.height / 2 - sYLeft)];
                
                [self addSubrenderable:sTile];
                [mVisibleTiles addObject:sTile];
            }
        }
    }
#else
    CGPoint sPosition = CGPointMake(-aRect.origin.x, -aRect.origin.y + aRect.size.height);

    [self setPosition:sPosition];
#endif
}


@end


//NSLog(@"visible rect = %@", NSStringFromCGRect(aRect));
//
//NSInteger sXIndex = floorf(aRect.origin.x / mTileSize.width);
//NSInteger sYIndex = mMapSize.height - floorf(aRect.origin.y / mTileSize.height);
//NSInteger sXCount = floorf(aRect.size.width / mTileSize.width);
//NSInteger sYCount = floorf(aRect.size.height / mTileSize.height);
//
//NSLog(@"sIndex = %d, %d", sXIndex, sYIndex);
//
//for (PBTileSprite *sTile in mVisibleTiles)
//{
//    [mTilePool addObject:sTile];
//    [sTile removeFromSuperrenderable];
//}
//[mVisibleTiles removeAllObjects];
//
//CGPoint sPoint = CGPointZero;
//
//for (NSInteger y = sYIndex; y > (sYIndex - sYCount); y--)
//{
//    for (NSInteger x = sXIndex; x < (sXIndex + sXCount); x++)
//    {
//        NSLog(@"x, y = %d, %d", x, y);
//        
//        NSInteger sIndex = [self tileIndexOfGridPosition:CGPointMake(x, y)];
//        if (sIndex > 0)
//        {
//            PBTileSprite *sTile = [self unusedTile];
//            [mVisibleTiles addObject:sTile];
//            [self addSubrenderable:sTile];
//            [sTile selectSpriteAtIndex:sIndex];
//            
//            CGPoint sPosition;
//            
//            sPosition.x = (x - sXIndex) * mTileSize.width - (mTileSize.width / 2);
//            sPosition.y = 390;
//            
//            [sTile setPosition:sPosition];
//        }
//    }
//    
//    sPoint.y += mTileSize.height;
//}
