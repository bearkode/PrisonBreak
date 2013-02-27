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
    // camelcode : comment on 13.2.27
    // [self texture] is NOT PBTileTexture.
    // occured unrecognized error.
//    return [(PBTileTexture *)[self texture] count];
    return 0;
}


- (void)selectSpriteAtIndex:(NSInteger)aIndex
{
    if (mIndex != aIndex)
    {
        mIndex = aIndex;
        
        // camelcode : comment on 13.2.27
        // [self texture] is NOT PBTileTexture.
        // occured unrecognized error.
//        [(PBTileTexture *)[self texture] selectTileAtIndex:mIndex];
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
