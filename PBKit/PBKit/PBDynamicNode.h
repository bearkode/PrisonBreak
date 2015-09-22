/*
 *  PBDynamicNode.h
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 29..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBSpriteNode.h"


@interface PBDynamicNode : PBSpriteNode


- (id)initWithSize:(CGSize)aSize;


- (void)setTextureSize:(CGSize)aSize;
- (void)updateTexture;

/*  */
- (void)contextDidChange:(CGContextRef)aContext;
- (void)drawInRect:(CGRect)aRect context:(CGContextRef)aContext;


@end
