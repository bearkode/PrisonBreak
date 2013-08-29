/*
 *  PBTileNode.h
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 29..
 *  Copyright (c) 2013 NHN. All rights reserved.
 *
 */

#import "PBSpriteNode.h"


@interface PBTileNode : PBSpriteNode


- (id)initWithImageNamed:(NSString *)aName tileSize:(CGSize)aTileSize;
- (id)initWithTexture:(PBTexture *)aTexture tileSize:(CGSize)aTileSize;


- (void)setTileSize:(CGSize)aTileSize;
- (CGSize)tileSize;

- (NSInteger)tileCount;
- (void)selectTileAtIndex:(NSInteger)aIndex;
- (BOOL)selectNextTile;
- (BOOL)selectPreviousTile;


@end
