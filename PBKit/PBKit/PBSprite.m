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
#import "PBShaderManager.h"
#import "PBShaderProgram.h"


@implementation PBSprite


- (id)initWithImageName:(NSString *)aImageName
{
    self = [super init];
    
    if (self)
    {
        GLuint sProgram = [[[PBShaderManager sharedManager] textureShader] programObject];
        [self setProgramObject:sProgram];
        
        PBTextureInfo *sTextureInfo = [[PBTextureInfo alloc] initWithImageName:aImageName];
        PBTexture     *sTexture     = [[PBTexture alloc] initWithTextureInfo:sTextureInfo];
        
        [sTextureInfo load];
        
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


- (PBVertex3)angle
{
    return [[self transform] angle];
}


- (void)setAngle:(PBVertex3)aAngle
{
    [[self transform] setAngle:aAngle];
}


@end
