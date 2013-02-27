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
#import "PBTileTexture.h"
#import "PBTextureManager.h"
#import "PBContext.h"


@implementation PBTileSprite
{
    NSInteger mIndex;
}


@synthesize index = mIndex;


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
        
        PBTexture *sTexture = [PBTextureManager textureWithImageName:aImageName];
        [sTexture loadIfNeeded];
        [sTexture setSize:aTileSize];
        
        [self setTexture:sTexture];
        
        [sTexture release];
    }
    
    return self;
}


- (id)initWithTexture:(PBTexture *)aTexture tileSize:(CGSize)aTileSize
{
    self = [super init];
    
    if (self)
    {
        [aTexture setSize:aTileSize];
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
    return [(PBTileTexture *)[self texture] count];
}


- (void)selectSpriteAtIndex:(NSInteger)aIndex
{
    if (mIndex != aIndex)
    {
        mIndex = aIndex;
        [(PBTileTexture *)[self texture] selectTileAtIndex:mIndex];
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
