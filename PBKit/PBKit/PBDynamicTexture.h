/*
 *  PBDynamicTexture.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 5..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTexture.h"


@interface PBDynamicTexture : PBTexture

@property (nonatomic, readonly) CGContextRef context;

- (id)initWithSize:(CGSize)aSize;

- (void)update;
- (BOOL)setSize:(CGSize)aSize;

- (void)drawInContext:(CGContextRef)aContext bounds:(CGRect)aBounds;

@end
