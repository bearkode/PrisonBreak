/*
 *  PBShapeNode.h
 *  PBKit
 *
 *  Created by camelkode on 13. 8. 29..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBNode.h"


@interface PBShapeNode : PBNode


+ (id)shapeNodeWithRect:(CGSize)aSize;


- (id)initWithRectNode:(CGSize)aSize;
- (void)setRect:(CGSize)aSize;


@end