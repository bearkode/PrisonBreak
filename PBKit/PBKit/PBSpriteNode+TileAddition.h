/*
 *  PBSpriteNode+TileAddition.h
 *  PBKit
 *
 *  Created by bearkode on 13. 6. 26..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBSpriteNode.h"


@interface PBSpriteNode (TileAddition)


- (void)setTileSize:(CGSize)aTileSize;
- (CGSize)tileSize;

- (NSInteger)tileCount;
- (void)selectTileAtIndex:(NSInteger)aIndex;
- (BOOL)selectNextTile;
- (BOOL)selectPreviousTile;


@end
