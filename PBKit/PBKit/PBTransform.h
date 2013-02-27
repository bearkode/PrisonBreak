/*
 *  PBTransform.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 28..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>
#import "PBVertices.h"


@class PBColor;


@interface PBTransform : NSObject


@property (nonatomic, assign) CGFloat    scale;
@property (nonatomic, assign) PBVertex3  angle;
@property (nonatomic, assign) PBVertex3  translate;
@property (nonatomic, retain) PBColor   *color;


+ (CGFloat)defaultScale;


- (void)setAlpha:(CGFloat)aAlpha;


@end
