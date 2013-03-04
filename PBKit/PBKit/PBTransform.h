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
@property (nonatomic, assign) BOOL       grayscale;
@property (nonatomic, assign) BOOL       sepia;
@property (nonatomic, assign) BOOL       blur;
@property (nonatomic, assign) BOOL       luminance;


+ (CGFloat)defaultScale;


- (void)setAlpha:(CGFloat)aAlpha;


@end
