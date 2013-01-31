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


@interface SampleParticleView : PBView <PBDisplayDelegate>
{
    NSMutableArray *mParticles;
}


- (void)fire:(CGPoint)aStartCoordinate count:(NSUInteger)aCount speed:(CGFloat)aSpeed;


@end
