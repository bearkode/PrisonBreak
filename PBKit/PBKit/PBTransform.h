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


+ (CGFloat)defaultScale;


- (void)setScale:(CGFloat)aScale;
- (CGFloat)scale;
- (void)setAngle:(PBVertex3)aAngle;
- (PBVertex3)angle;
- (void)setTranslate:(PBVertex3)aTranslate;
- (PBVertex3)translate;
- (void)setColor:(PBColor *)aColor;
- (PBColor *)color;
- (void)setGrayscale:(BOOL)aGrayscale;
- (BOOL)grayscale;
- (void)setSepia:(BOOL)aSepia;
- (BOOL)sepia;
- (void)setBlur:(BOOL)aBlur;
- (BOOL)blur;
- (void)setLuminance:(BOOL)aLuminance;
- (BOOL)luminance;

- (void)setDirty:(BOOL)aDirty;
- (BOOL)checkDirty;
- (void)setAlpha:(CGFloat)aAlpha;
- (CGFloat)alpha;


@end
