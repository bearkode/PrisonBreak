/*
 *  IsoMap.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 2. 21..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "IsoMap.h"


@implementation IsoMap
{
    CGSize         mMapSize;
    CGSize         mTileSize;
    CGRect         mBounds;
    PBTextureInfo *mTextureInfo;
    NSArray       *mIndexArray;
}


@synthesize bounds = mBounds;


- (NSInteger)indexAtGridPosition:(CGPoint)aPoint
{
    NSInteger sResult = -1;
    
    if (CGRectContainsPoint(CGRectMake(0, 0, mMapSize.width, mMapSize.height), aPoint))
    {
        sResult = [[mIndexArray objectAtIndex:(aPoint.y * mMapSize.height + aPoint.x)] integerValue] - 1;
    }

    return sResult;
}


- (CGPoint)pointFromGridPosition:(CGPoint)aGridPosition
{
    CGPoint sPoint;
    
    sPoint.x = aGridPosition.x * mTileSize.width / 2;
    sPoint.y = aGridPosition.y * mTileSize.height / 2;
    sPoint.x = sPoint.x - (mTileSize.width / 2 * aGridPosition.y);
    sPoint.y = sPoint.y + (mTileSize.height / 2 * aGridPosition.x);
    sPoint.y = -(sPoint.y + (mTileSize.height / 2));
    
    return sPoint;
}


- (void)setupTiles
{
    PBBeginTimeCheck();
    for (NSInteger y = 0; y < mMapSize.height; y++)
    {
        for (NSInteger x = 0; x < mMapSize.width; x++)
        {
            NSInteger sIndex = [self indexAtGridPosition:CGPointMake(x, y)];
            CGPoint   sPoint = [self pointFromGridPosition:CGPointMake(x, y)];

            PBTileSprite *sTile = [[PBTileSprite alloc] initWithTextureInfo:mTextureInfo tileSize:mTileSize];
            [sTile selectSpriteAtIndex:sIndex];
            [sTile setPosition:sPoint];
            [self addSubrenderable:sTile];
            [sTile release];
        }
    }
    PBEndTimeCheck();
}


#pragma mark -


- (id)initWithContentsOfFile:(NSString *)aPath
{
    self = [super init];
    
    if (self)
    {
        NSData       *sData     = [NSData dataWithContentsOfFile:aPath];
        NSDictionary *sJsonDict = [NSJSONSerialization JSONObjectWithData:sData options:0 error:nil];

//        NSLog(@"sJsonDict = %@", sJsonDict);
        
        mMapSize.width   = [[sJsonDict objectForKey:@"width"] integerValue];
        mMapSize.height  = [[sJsonDict objectForKey:@"height"] integerValue];
        mTileSize.width  = [[sJsonDict objectForKey:@"tilewidth"] integerValue];
        mTileSize.height = [[sJsonDict objectForKey:@"tileheight"] integerValue];
        
        mBounds.origin.x    = 0;
        mBounds.origin.y    = 0;
        mBounds.size.width  = mMapSize.width * (mTileSize.width / 2) + mMapSize.height * (mTileSize.width / 2);
        mBounds.size.height = mMapSize.width * (mTileSize.height / 2) + mMapSize.height * (mTileSize.height / 2);
        
        NSLog(@"mBounds = %@", NSStringFromCGRect(mBounds));
        
        NSLog(@"mapsize  = %@", NSStringFromCGSize(mMapSize));
        NSLog(@"tilesize = %@", NSStringFromCGSize(mTileSize));
        NSLog(@"bounds   = %@", NSStringFromCGRect(mBounds));
        
        NSDictionary *sTileSet   = [[sJsonDict objectForKey:@"tilesets"] objectAtIndex:0];
        NSString     *sImageName = [sTileSet objectForKey:@"image"];
        
        mTextureInfo = [[PBTextureInfo alloc] initWithImageName:sImageName];
        [mTextureInfo loadIfNeeded];
        
        mIndexArray = [[[[sJsonDict objectForKey:@"layers"] objectAtIndex:0] objectForKey:@"data"] retain];
        
//        NSLog(@"index array = %@", mIndexArray);
        [self setPosition:CGPointMake(0, 0)];
        [self setupTiles];
    }
    
    return self;
}


- (void)dealloc
{
    [mTextureInfo release];
    [mIndexArray release];
    
    [super dealloc];
}


@end
