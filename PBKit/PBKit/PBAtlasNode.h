/*
 *  PBAtlasNode.h
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 29..
 *  Copyright (c) 2013 NHN. All rights reserved.
 *
 */

#import "PBSpriteNode.h"


@class PBAtlas;


@interface PBAtlasNode : PBSpriteNode


- (id)initWithAtlas:(PBAtlas *)aAtlas key:(id <NSCopying>)aKey;


- (void)setKey:(id <NSCopying>)aKey;


@end
