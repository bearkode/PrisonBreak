/*
 *  PBSpriteNode+DynamicAddition.h
 *  PBKit
 *
 *  Created by bearkode on 13. 6. 26..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBSpriteNode.h"


@interface PBSpriteNode (DynamicAddition)


- (void)setDynamicTextureSize:(CGSize)aSize;
- (void)updateDynamicTexture;

/*  */
- (void)drawInRect:(CGRect)aRect context:(CGContextRef)aContext;


@end
