/*
 *  SampleSpriteView.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
*/


#import <UIKit/UIKit.h>
#import <PBKit.h>


@interface SampleSpriteView : PBView
{
    NSMutableArray  *mTextures;
    NSUInteger       mSpriteIndex;
    CGFloat          mScale;
    CGFloat          mAngle;
}


@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat angle;


@end
