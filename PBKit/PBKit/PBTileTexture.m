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
    
    mSize = aSize;
    
    mTileSize = CGSizeMake(mSize.width / [self imageSize].width, mSize.height / [self imageSize].height);
    mColCount = [self imageSize].width / mSize.width;
    mRowCount = [self imageSize].height / mSize.height;
    
    CGFloat sImageScale = [self imageScale];
    
    mSize.width  *= [self scale] / sImageScale;
    mSize.height *= [self scale] / sImageScale;

    [self didChangeValueForKey:@"size"];
}


- (CGSize)size
{
    return mSize;
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
