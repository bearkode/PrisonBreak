/*
 *  PBSpriteNode.h
 *  PBKit
 *
 *  Created by bearkode on 13. 6. 26..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBNode.h"


@interface PBSpriteNode : PBNode


+ (id)spriteNodeWithImageNamed:(NSString *)aName;
+ (id)spriteNodeWithTexture:(PBTexture *)aTexture;


- (id)initWithImageNamed:(NSString *)aName;
- (id)initWithTexture:(PBTexture *)aTexture;
- (id)initDynamicSpriteWithSize:(CGSize)aSize;


- (void)setTexture:(PBTexture *)aTexture;
- (PBTexture *)texture;
- (CGSize)textureSize;


@end