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


- (void)reset;
- (void)setTotalFrame:(NSUInteger)aTotalFrame;


- (void)arrangeTimelineForRotates:(NSArray *)aRotates setupPoseAngle:(CGFloat)aSetupPoseAngle;
- (CGFloat)rotateForFrame:(NSUInteger)aFrame;


- (void)arrangeTimelineForTranslstes:(NSArray *)aTranslates setupPoseOffset:(CGPoint)aSetupPoseOffset;
- (CGPoint)translateForFrame:(NSUInteger)aFrame;


- (void)arrangeTimelineForScales:(NSArray *)aScales setupPoseScale:(CGPoint)aSetupPoseScale;
- (CGPoint)scaleForFrame:(NSUInteger)aFrame;


@end
