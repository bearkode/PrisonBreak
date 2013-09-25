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
} ColorEffectFilterType;


#define kDefaultScale 1.0f
#define kDefaultAngle 0.0f
#define kDefaultAlpha 1.0f


@interface TextureView : PBCanvas<PBSceneDelegate>
{
    CGFloat mScaleX;
    CGFloat mScaleY;
    CGFloat mAngle;
    CGFloat mAlpha;
}


@property (nonatomic, assign) CGFloat scaleX;
@property (nonatomic, assign) CGFloat scaleY;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat alpha;


@end
