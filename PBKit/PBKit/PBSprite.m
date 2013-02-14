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
#import "PBTextureInfoManager.h"


@implementation PBSprite


- (id)initWithImageName:(NSString *)aImageName
{
    self = [super init];
    
    if (self)
    {
        GLuint sProgram = [[[PBShaderManager sharedManager] textureShader] program];
        [self setProgram:sProgram];
        
        PBTextureInfo *sTextureInfo = [PBTextureInfoManager textureInfoWithImageName:aImageName];
        PBTexture     *sTexture     = [[PBTexture alloc] initWithTextureInfo:sTextureInfo];
        
        [sTextureInfo loadIfNeeded];
        
        [self setTexture:sTexture];

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
