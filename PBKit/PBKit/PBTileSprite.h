/*
 *  PBTileSprite.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 13..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBLayer.h"


@class PBTexture;


@interface PBTileSprite : PBLayer


@property NSInteger index;


- (id)initWithImageName:(NSString *)aImageName tileSize:(CGSize)aTileSize;
- (id)initWithTexture:(PBTexture *)aTexture tileSize:(CGSize)aTileSize;

- (NSInteger)count;
- (void)selectSpriteAtIndex:(NSInteger)aIndex;
- (BOOL)selectNextSprite;
- (BOOL)selectPreviousSprite;

@end
