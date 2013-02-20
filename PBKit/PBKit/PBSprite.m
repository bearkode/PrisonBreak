/*
 *  PBSprite.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 13..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBSprite.h"
#import "PBTextureInfo.h"
#import "PBTexture.h"
#import "PBProgramManager.h"
#import "PBProgram.h"
#import "PBTextureInfoManager.h"


@implementation PBSprite


- (id)initWithImageName:(NSString *)aImageName
{
    self = [super init];
    
    if (self)
    {
        [self setProgram:[[PBProgramManager sharedManager] bundleProgram]];
        
        PBTextureInfo *sTextureInfo = [PBTextureInfoManager textureInfoWithImageName:aImageName];
        PBTexture     *sTexture     = [[PBTexture alloc] initWithTextureInfo:sTextureInfo];
        
        [sTextureInfo loadIfNeeded];
        
        [self setTexture:sTexture];

        [sTexture release];
    }
    
    return self;
}


- (id)initWithTextureInfo:(PBTextureInfo *)aTextureInfo
{
    self = [super init];
    
    if (self)
    {
        [self setProgram:[[PBProgramManager sharedManager] bundleProgram]];
        
        PBTexture *sTexture = [[PBTexture alloc] initWithTextureInfo:aTextureInfo];
        
        [self setTexture:sTexture];
        
        [sTexture release];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


@end
