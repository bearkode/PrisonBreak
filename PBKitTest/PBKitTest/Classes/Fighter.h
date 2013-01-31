/*
 *  Fighter.h
 *  PBKitTest
 *
 *  Created by bearkode on 13. 1. 30..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#import <PBKit.h>


@interface Fighter : PBRenderable

- (void)setScale:(CGFloat)aScale;

- (void)yawLeft;
- (void)yawRight;
- (void)balance;

@end
