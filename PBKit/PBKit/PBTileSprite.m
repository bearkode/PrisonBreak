/*
 *  PBTileSprite.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 13..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTileSprite.h"
#import "PBShaderManager.h"
#import "PBShaderProgram.h"
#import "PBTextureInfo.h"
#import "PBTileTexture.h"


@implementation PBTileSprite
{
    NSInteger mIndex;
}


@synthesize index = mIndex;


#pragma mark -


- (id)initWithImageName:(NSString *)aImageName tileSize:(CGSize)aTileSize
{
    self = [super init];
    
    if (self)
    {
        GLuint sProgram = [[[PBShaderManager sharedManager] textureShader] program];
        [self setProgram:sProgram];
        
        PBTextureInfo *sTextureInfo = [[PBTextureInfo alloc] initWithImageName:aImageName];
        PBTileTexture *sTexture     = [[PBTileTexture alloc] initWithTextureInfo:sTextureInfo];
        
        [sTextureInfo load];
        [sTexture setSize:aTileSize];
        
        [self setTexture:sTexture];
        
        [sTextureInfo release];
        [sTexture release];
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
    mIndex = aIndex;
    [(PBTileTexture *)[self texture] selectTileAtIndex:mIndex];
}


- (BOOL)selectNextSprite
{
    BOOL sResult = NO;
    
    mIndex++;
    
    if (mIndex >= [self count])
    {
        mIndex = 0;
        sResult = YES;
    }
    
    [self selectSpriteAtIndex:mIndex];
    
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
