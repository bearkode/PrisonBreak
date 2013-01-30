/*
 *  SampleTextureViewController.h
 *  PBKitTest
 *
 *  Created by sshanks on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class SampleTextureView;
@class PVRTextureView;
@class SampleSpriteView;


@interface SampleTextureViewController : UIViewController
{
    SampleTextureView *mTextureView;
    PVRTextureView    *mPVRTextureView;
    SampleSpriteView  *mSpriteView;
    
    IBOutlet UISlider *mScaleSlide;
    IBOutlet UISlider *mAngleSlide;
}

@end
