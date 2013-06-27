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
#import "PBDynamicTexture.h"
#import "PBContext.h"


@interface PBSpriteNode (TileAddition)


- (void)setTileSize:(CGSize)aSize;


@end


@implementation PBSpriteNode
{
    PBTexture *mTexture;
    NSInteger  mTileIndex;
}


#pragma mark -
#pragma mark Privates


- (NSUInteger)tileIndex
{
    return mTileIndex;
}


- (void)setTileIndex:(NSUInteger)aTileIndex
{
    mTileIndex = aTileIndex;
}


#pragma mark -


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
        mTileIndex = -1;
    }
    
    return self;
}


- (id)initWithTexture:(PBTexture *)aTexture
{
    self = [super init];
    
    if (self)
    {
        [self setTexture:aTexture];
        mTileIndex = -1;
    }
    
    return self;
}


- (id)initDynamicSpriteWithSize:(CGSize)aSize
{
    self = [super init];
    
    if (self)
    {
        PBDynamicTexture *sTexture = [[PBDynamicTexture alloc] initWithSize:aSize scale:[[UIScreen mainScreen] scale]];
        [self setTexture:sTexture];
        [sTexture setDrawDelegate:self];
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


+ (Class)meshClass
{
    return [PBTileMesh class];
}


- (void)setTexture:(PBTexture *)aTexture
{
    [mTexture setDelegate:nil];
    [mTexture autorelease];
    
    mTexture = [aTexture retain];
    [mTexture setDelegate:self];

    if ([aTexture isLoaded])
    {
        [self setTileSize:[aTexture size]];
        [[self mesh] setTexture:aTexture];
    }
}


- (PBTexture *)texture
{
    return mTexture;
}


- (void)textureDidResize:(PBTexture *)aTexture
{
    [PBContext performBlockOnMainThread:^{
        [[self mesh] updateMeshData];
    }];
}


- (void)textureDidLoad:(PBTexture *)aTexture
{
    [PBContext performBlockOnMainThread:^{
        [self setTileSize:[aTexture size]];        
        [[self mesh] setTexture:mTexture];
    }];
}


@end
