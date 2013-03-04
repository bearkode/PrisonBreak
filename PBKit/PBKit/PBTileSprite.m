/*
 *  PBTileSprite.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 13..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTileSprite.h"
#import "PBProgramManager.h"
#import "PBProgram.h"
#import "PBTextureManager.h"
#import "PBContext.h"
#import "PBTileMesh.h"
#import "PBTexture.h"


@implementation PBTileSprite
{
    NSInteger mIndex;
}


@synthesize index = mIndex;


+ (Class)meshClass
{
    return [PBTileMesh class];
}


#pragma mark -


- (id)initWithImageName:(NSString *)aImageName tileSize:(CGSize)aTileSize
{
    NSAssert(aImageName, @"");
    
    self = [super init];
    
    if (self)
    {
        [PBContext performBlockOnMainThread:^{
            [self setProgram:[[PBProgramManager sharedManager] program]];
        }];
        
        [(PBTileMesh *)[self mesh] setTileSize:aTileSize];
        
        PBTexture *sTexture = [PBTextureManager textureWithImageName:aImageName];
        [sTexture loadIfNeeded];
        [self setTexture:sTexture];
    }
    
    return self;
}


- (id)initWithTexture:(PBTexture *)aTexture tileSize:(CGSize)aTileSize
{
    self = [super init];
    
    if (self)
    {
        [PBContext performBlockOnMainThread:^{
            [self setProgram:[[PBProgramManager sharedManager] program]];
        }];
        
        [(PBTileMesh *)[self mesh] setTileSize:aTileSize];
        [self setTexture:aTexture];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (NSInteger)count
{
    return [(PBTileMesh *)[self mesh] count];
}


- (void)selectSpriteAtIndex:(NSInteger)aIndex
{
    if (mIndex != aIndex)
    {
        mIndex = aIndex;
        [(PBTileMesh *)[self mesh] selectTileAtIndex:aIndex];
    }
}


- (BOOL)selectNextSprite
{
    BOOL      sResult = NO;
    NSInteger sIndex = mIndex + 1;

    if (sIndex >= [self count])
    {
        sIndex = 0;
        sResult = YES;
    }
    
    [self selectSpriteAtIndex:sIndex];
    
    return sResult;
}


- (BOOL)selectPreviousSprite
{
    BOOL sResult = NO;
    
    mIndex--;
    
    if (mIndex < 0)
    {
        mIndex = [self count] - 1;
        sResult = YES;
    }
    
    [self selectSpriteAtIndex:mIndex];
    
    return sResult;
}


@end
