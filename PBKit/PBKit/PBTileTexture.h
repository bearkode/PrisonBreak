/*
 *  PBTileTexture.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 7..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTexture.h"


@interface PBTileTexture : PBTexture

- (void)setSize:(CGSize)aSize;
- (CGSize)size;

- (NSInteger)count;
- (void)selectTileAtIndex:(NSInteger)aIndex;

@end
