/*
 *  PBTextureLoadOperation.m
 *  PBKit
 *
 *  Created by cgkim on 13. 1. 28..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#import "PBTextureLoadOperation.h"
#import "PBTextureUtils.h"
#import "PBTexture.h"


@implementation PBTextureLoadOperation
{
    PBTexture *mTexture;
}


#pragma mark -


+ (id)textureLoadOperationWithTexture:(PBTexture *)aTexture
{
    return [[[PBTextureLoadOperation alloc] initWithTexture:aTexture] autorelease];
}


#pragma mark -


- (id)initWithTexture:(PBTexture *)aTexture
{
    self = [super init];
    
    if (self)
    {
        mTexture = [aTexture retain];
    }
    
    return self;
}


- (void)dealloc
{
    [mTexture release];
    
    [super dealloc];
}


#pragma mark -


- (void)main
{
    [mTexture load];
}


@end
