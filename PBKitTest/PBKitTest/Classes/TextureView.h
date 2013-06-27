/*
 *  TextureView.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 2. 19..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import <PBKit.h>


typedef enum
{
    kTextureType = 0,
    kSpriteType
} TextureType;


typedef enum
{
    kNormalColor = 0,
    kGrayscaleEffect,
    kSepiaEffect,
    kBlurEffect,
    kLuminanceEffect
} ColorEffectFilterType;


#define kDefaultScale 1.0f
#define kDefaultAngle 0.0f
#define kDefaultAlpha 1.0f


@interface TextureView : PBCanvas<PBSceneDelegate>
{
    CGFloat mScale;
    CGFloat mAngle;
    CGFloat mAlpha;
    BOOL    mBlur;
    BOOL    mGrayScale;
    BOOL    mSepia;
    BOOL    mLuminance;
}


@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) BOOL    blur;
@property (nonatomic, assign) BOOL    grayScale;
@property (nonatomic, assign) BOOL    sepia;
@property (nonatomic, assign) BOOL    luminance;


@end
