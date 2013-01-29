/*
 *  SampleParticleViewController.h
 *  PBKitTest
 *
 *  Created by sshanks on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <UIKit/UIKit.h>


@class SampleParticleView;


@interface SampleParticleViewController : UIViewController
{
    SampleParticleView *mParticleView;

    IBOutlet UISlider  *mCountSlide;
    IBOutlet UILabel   *mCountLabel;
    NSUInteger          mParticleCount;
    
    IBOutlet UISlider  *mSpeedSlide;
    IBOutlet UILabel   *mSpeedLabel;
    CGFloat             mSpeed;
}


@end
