/*
 *  SkeletonTimeline.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 9. 11..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>


@interface SkeletonTimeline : NSObject


@property (nonatomic, assign) CGFloat rotateVariation;

- (void)reset;


- (void)setRotateAngle:(CGFloat)aAngle angleVariation:(CGFloat)aAngleVariation forKeyFrame:(NSUInteger)aKeyFrame;
- (NSDictionary *)rotateTimelineForKeyFrame:(NSUInteger)aKeyFrame;


@end
