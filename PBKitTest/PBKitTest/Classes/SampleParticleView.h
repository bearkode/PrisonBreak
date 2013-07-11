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


typedef enum
{
    kSelectParticleNone = 0,
    kSelectParticlRadial,
    kSelectParticleFlame,
    kSelectParticleRain
} ParticleSelectType;


@interface SampleParticleView : PBCanvas<PBSceneDelegate>


@property (nonatomic, assign) ParticleSelectType type;

- (void)radial;
- (void)flame;
- (void)rain;


@end
