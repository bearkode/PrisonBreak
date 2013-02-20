/*
 *  PBTileSprite.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 13..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBRenderable.h"


@class PBTextureInfo;


@interface PBTileSprite : PBRenderable


@property NSInteger index;


- (id)initWithImageName:(NSString *)aImageName tileSize:(CGSize)aTileSize;
- (id)initWithTextureInfo:(PBTextureInfo *)aTextureInfo tileSize:(CGSize)aTileSize;

- (NSInteger)count;
- (void)selectSpriteAtIndex:(NSInteger)aIndex;
- (BOOL)selectNextSprite;
- (BOOL)selectPreviousSprite;

@end
