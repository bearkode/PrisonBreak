/*
 *  PBDrawingSprite.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 13..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBNode.h"


@interface PBDrawingSprite : PBNode


@property (nonatomic, assign) id delegate;

- (id)initWithSize:(CGSize)aSize;

- (void)setSize:(CGSize)aSize;
- (void)refresh;

@end


@protocol PBDrawingSpriteDelegate <NSObject>

- (void)sprite:(PBDrawingSprite *)aSprite drawInRect:(CGRect)aRect context:(CGContextRef)aContext;

@end