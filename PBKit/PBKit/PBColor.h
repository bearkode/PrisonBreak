/*
 *  PBColor.h
 *  PBKit
 *
 *  Created by Park Heon-jun on 12. 7. 13..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


#import <UIKit/UIKit.h>


@interface PBColor : NSObject


@property (nonatomic, assign) GLfloat r;
@property (nonatomic, assign) GLfloat g;
@property (nonatomic, assign) GLfloat b;
@property (nonatomic, assign) GLfloat a;


+ (PBColor *)colorWithWhite:(GLfloat)aWhite alpha:(GLfloat)aAlpha;
+ (PBColor *)colorWithRed:(GLfloat)aRed green:(GLfloat)aGreen blue:(GLfloat)aBlue alpha:(GLfloat)aAlpha;
+ (PBColor *)colorWithRGB:(int)aRGB alpha:(GLfloat)aAlpha;


+ (PBColor *)blackColor;
+ (PBColor *)darkGrayColor;
+ (PBColor *)lightGrayColor;
+ (PBColor *)whiteColor;
+ (PBColor *)grayColor;
+ (PBColor *)redColor;
+ (PBColor *)greenColor;
+ (PBColor *)blueColor;
+ (PBColor *)cyanColor;
+ (PBColor *)yellowColor;
+ (PBColor *)magentaColor;
+ (PBColor *)orangeColor;
+ (PBColor *)purpleColor;
+ (PBColor *)brownColor;
+ (PBColor *)clearColor;


+ (PBColor *)currentColor;


- (id)initWithWhite:(GLfloat)aWhite alpha:(GLfloat)aAlpha;
- (id)initWithRed:(GLfloat)aRed green:(GLfloat)aGreen blue:(GLfloat)aBlue alpha:(GLfloat)aAlpha;
- (id)initWithRGB:(int)aRGB alpha:(GLfloat)aAlpha;


@end
