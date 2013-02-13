/*
 *  PBTileTexture.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 7..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTileTexture.h"


@implementation PBTileTexture
{
    CGSize    mTileSize;
    NSInteger mColCount;
    NSInteger mRowCount;
}


- (void)setSize:(CGSize)aSize
{
    [self willChangeValueForKey:@"size"];

    CGFloat sImageScale = [self imageScale];
    
    mSize = aSize;
    mSize.width  *= [self scale] / sImageScale;
    mSize.height *= [self scale] / sImageScale;
    
    mTileSize = CGSizeMake(aSize.width / [self imageSize].width, aSize.height / [self imageSize].height);;
    mColCount = [self imageSize].width / aSize.width;
    mRowCount = [self imageSize].height / aSize.height;

    [self selectTileAtIndex:0];
    
    [self didChangeValueForKey:@"size"];
}


- (CGSize)size
{
    return mSize;
}


- (NSInteger)count
{
    return mColCount * mRowCount;
}


- (void)selectTileAtIndex:(NSInteger)aIndex
{
    NSInteger y = aIndex / mRowCount;
    NSInteger x = aIndex - (y * mColCount);
    
    GLfloat sVertices[8];
    
    sVertices[0] = mTileSize.width * x;
    sVertices[1] = mTileSize.height * y;
    sVertices[2] = sVertices[0];
    sVertices[3] = sVertices[1] + mTileSize.height;
    sVertices[4] = sVertices[0] + mTileSize.width;
    sVertices[5] = sVertices[1] + mTileSize.height;
    sVertices[6] = sVertices[0] + mTileSize.width;
    sVertices[7] = sVertices[1];
    
    [self setVertices:sVertices];
}


@end
