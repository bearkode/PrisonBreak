/*
 *  PBSpriteNode.m
 *  PBKit
 *
 *  Created by bearkode on 13. 6. 26..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBSpriteNode.h"
#import "PBTextureManager.h"
#import "PBTileMesh.h"
#import "PBTexture.h"
#import "PBContext.h"
#import "PBNodePrivate.h"


@implementation PBSpriteNode
{
    PBTexture *mTexture;
}


#pragma mark -


+ (Class)meshClass
{
    return [PBMesh class];
}


+ (id)spriteNodeWithImageNamed:(NSString *)aName
{
    return [[[PBSpriteNode alloc] initWithImageNamed:aName] autorelease];
}


+ (id)spriteNodeWithTexture:(PBTexture *)aTexture
{
    return [[[PBSpriteNode alloc] initWithTexture:aTexture] autorelease];
}


#pragma mark -


- (id)initWithImageNamed:(NSString *)aName
{
    self = [super init];
    
    if (self)
    {
        [self setTexture:[PBTextureManager textureWithImageName:aName]];
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
    [mTexture setDelegate:nil];
    [mTexture release];

    [super dealloc];
}


#pragma mark -


- (void)setTexture:(PBTexture *)aTexture
{
    [mTexture setDelegate:nil];
    [mTexture autorelease];
    
    mTexture = [aTexture retain];
    [mTexture setDelegate:self];

    if ([aTexture isLoaded])
    {
        [[self mesh] setTexture:aTexture];
    }
}


- (PBTexture *)texture
{
    return mTexture;
}


- (CGSize)textureSize
{
    return [mTexture size];
}


#pragma mark -
#pragma mark TextureDelegate


- (void)textureDidResize:(PBTexture *)aTexture
{
    [PBContext performBlockOnMainThread:^{
        [[self mesh] updateMeshData];
    }];
}


- (void)textureDidLoad:(PBTexture *)aTexture
{
    [PBContext performBlockOnMainThread:^{
        [[self mesh] setTexture:mTexture];
    }];
}


@end
