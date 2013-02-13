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
    NSInteger mIndex;
}


- (id)initWithTextureInfo:(PBTextureInfo *)aTextureInfo
{
    self = [super init];
    
    if (self)
    {
        PBTileTexture *sTexture = [[[PBTileTexture alloc] initWithTextureInfo:aTextureInfo] autorelease];
        [sTexture setSize:CGSizeMake(64, 64)];
        [self setTexture:sTexture];
        
        GLuint sProgram = [[[PBShaderManager sharedManager] textureShader] programObject];
        [self setProgramObject:sProgram];
        
        mIndex = 0;
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


- (void)update
{
    mIndex++;
    
    if (mIndex == 25)
    {
        [self setHidden:YES];
    }
    else
    {
        [(PBTileTexture *)[self texture] selectTileAtIndex:mIndex];
    }
}


@end
