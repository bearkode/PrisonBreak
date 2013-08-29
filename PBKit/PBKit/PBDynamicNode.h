/*
 *  PBDynamicNode.h
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 29..
 *  Copyright (c) 2013 NHN. All rights reserved.
 *
 */

#import "PBSpriteNode.h"


@interface PBDynamicNode : PBSpriteNode


- (id)initWithSize:(CGSize)aSize;


- (void)setTextureSize:(CGSize)aSize;
- (void)updateTexture;

/*  */
- (void)drawInRect:(CGRect)aRect context:(CGContextRef)aContext;


@end
