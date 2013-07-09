/*
 *  SampleParticleView.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
*/


#import <UIKit/UIKit.h>
#import <PBKit.h>


@interface SampleParticleView : PBCanvas<PBSceneDelegate>


- (void)radial;
- (void)flame;

@end
