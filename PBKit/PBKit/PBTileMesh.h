/*
 *  PBTileMesh.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 28..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBMesh.h"


@interface PBTileMesh : PBMesh


- (void)setTileSize:(CGSize)aTileSize;
- (NSInteger)count;


- (void)selectTileAtIndex:(NSInteger)aIndex;


@end