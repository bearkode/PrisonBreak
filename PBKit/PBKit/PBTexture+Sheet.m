/*
 *  PBTexture+Sheet.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 4..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTexture+Sheet.h"


@implementation PBTexture (Sheet)


- (void)selectTileAtIndex:(NSInteger)aIndex
{
    CGSize    sTileSize = CGSizeMake([self tileSize].width / [self size].width, [self tileSize].height / [self size].height);
    NSInteger sColCount = [self size].width / [self tileSize].width;
    NSInteger sRowCount = [self size].height / [self tileSize].height;
    NSInteger y = aIndex / sRowCount;
    NSInteger x = aIndex - (y * sColCount);

    GLfloat sVertices[8];
    
    sVertices[0] = sTileSize.width * x;
    sVertices[1] = sTileSize.height * y;
    sVertices[2] = sVertices[0];
    sVertices[3] = sVertices[1] + sTileSize.height;
    sVertices[4] = sVertices[0] + sTileSize.width;
    sVertices[5] = sVertices[1] + sTileSize.height;
    sVertices[6] = sVertices[0] + sTileSize.width;
    sVertices[7] = sVertices[1];
    
    [self setVertices:sVertices];
}


@end
