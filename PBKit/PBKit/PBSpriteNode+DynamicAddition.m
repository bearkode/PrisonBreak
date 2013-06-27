/*
 *  PBSpriteNode+DynamicAddition.m
 *  PBKit
 *
 *  Created by bearkode on 13. 6. 26..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBSpriteNode+DynamicAddition.h"
#import "PBDynamicTexture.h"


@interface PBSpriteNode (TileAddition)


- (void)setTileSize:(CGSize)aSize;


@end


@implementation PBSpriteNode (DynamicAddition)


- (void)setDynamicTextureSize:(CGSize)aSize
{

    [(PBDynamicTexture *)[self texture] setSize:aSize];
    [(PBDynamicTexture *)[self texture] update];
    [self setTileSize:aSize];
}


- (void)updateDynamicTexture
{
    [(PBDynamicTexture *)[self texture] update];
}


- (void)texture:(PBDynamicTexture *)aTexture drawInRect:(CGRect)aRect context:(CGContextRef)aContext
{
    NSAssert(aContext, @"");

    [self drawInRect:aRect context:(CGContextRef)aContext];
}


- (void)drawInRect:(CGRect)aRect context:(CGContextRef)aContext
{

}


@end
