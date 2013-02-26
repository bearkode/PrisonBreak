/*
 *  PBTileTexture.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 7..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTileTexture.h"
#import "PBTexture+Private.h"


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
    
    [super setSize:CGSizeMake(aSize.width / sImageScale, aSize.height / sImageScale)];
    
    mTileSize = CGSizeMake(aSize.width / [self imageSize].width, aSize.height / [self imageSize].height);;
    mColCount = [self imageSize].width / aSize.width;
    mRowCount = [self imageSize].height / aSize.height;

    [self selectTileAtIndex:0];
    
    [self didChangeValueForKey:@"size"];
}


- (NSInteger)count
{
    return mColCount * mRowCount;
}


- (void)selectTileAtIndex:(NSInteger)aIndex
{
    NSInteger y = aIndex / mColCount;
    NSInteger x = fmodf((float)aIndex, (float)mColCount);
    
    GLfloat sTexCoords[8];
    
    sTexCoords[0] = mTileSize.width * x;
    sTexCoords[1] = mTileSize.height * y;
    sTexCoords[2] = sTexCoords[0];
    sTexCoords[3] = sTexCoords[1] + mTileSize.height;
    sTexCoords[4] = sTexCoords[0] + mTileSize.width;
    sTexCoords[5] = sTexCoords[1] + mTileSize.height;
    sTexCoords[6] = sTexCoords[0] + mTileSize.width;
    sTexCoords[7] = sTexCoords[1];
    
    [self setTexCoords:sTexCoords];
}


@end
