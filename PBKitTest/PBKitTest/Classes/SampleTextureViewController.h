/*
 *  SampleTextureViewController.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <UIKit/UIKit.h>


@class SampleTextureView;
@class SampleSpriteView;


@interface SampleTextureViewController : UIViewController
{
    SampleTextureView *mTextureView;
    SampleSpriteView  *mSpriteView;
    
    IBOutlet UISlider *mScaleXSlide;
    IBOutlet UISlider *mScaleYSlide;
    IBOutlet UISlider *mAngleSlide;
    IBOutlet UISlider *mAlphaSlide;
}


@end
