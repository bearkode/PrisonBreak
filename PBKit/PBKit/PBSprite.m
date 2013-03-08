/*
 *  PBSprite.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 13..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBSprite.h"
#import "PBTexture.h"
#import "PBProgramManager.h"
#import "PBProgram.h"
#import "PBTextureManager.h"
#import "PBContext.h"


@implementation PBSprite


- (id)initWithImageName:(NSString *)aImageName
{
    self = [super init];
    
    if (self)
    {
        PBTexture *sTexture = [PBTextureManager textureWithImageName:aImageName];
        [sTexture loadIfNeeded];
        [self setTexture:sTexture];
    }
    
    return self;
}


- (id)initWithTexture:(PBTexture *)aTexture
{
    self = [super init];
    
    if (self)
    {
        [self setTexture:aTexture];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


@end
