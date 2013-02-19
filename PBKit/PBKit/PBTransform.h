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


struct
{
    float m[4][4];
} typedef PBMatrix4;


typedef struct {
    CGFloat x1;
    CGFloat x2;
    CGFloat y1;
    CGFloat y2;
} PBMatrix;


static const PBMatrix4 PBMatrix4Identity =
{
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
};


@class PBColor;


@interface PBTransform : NSObject


@property (nonatomic, assign) CGFloat    scale;
@property (nonatomic, assign) PBVertex3  translate;
@property (nonatomic, assign) PBVertex3  angle;
@property (nonatomic, retain) PBColor   *color;
@property (nonatomic, assign) BOOL       grayScaleEffect;
@property (nonatomic, assign) BOOL       sepiaEffect;
@property (nonatomic, assign) BOOL       luminanceEffect;
@property (nonatomic, assign) BOOL       blurEffect;


- (void)setAlpha:(CGFloat)aAlpha;


@end
