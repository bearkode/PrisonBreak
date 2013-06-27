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
//@class PVRTextureView;
@class SampleSpriteView;


@interface SampleTextureViewController : UIViewController
{
    SampleTextureView *mTextureView;
//    PVRTextureView    *mPVRTextureView;
    SampleSpriteView  *mSpriteView;
    
    IBOutlet UISlider *mScaleSlide;
    IBOutlet UISlider *mAngleSlide;
    IBOutlet UISlider *mAlphaSlide;
    IBOutlet UISwitch *mBlurSwitch;
    IBOutlet UISwitch *mGrayScaleSwitch;
    IBOutlet UISwitch *mLuminanceSwitch;
    IBOutlet UISwitch *mSepiaSwitch;
}


@end
