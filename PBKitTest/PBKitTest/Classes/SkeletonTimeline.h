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


@property (nonatomic, assign) CGFloat   rotateLinearVariation;
@property (nonatomic, assign) NSArray  *rotateBezierVariations;
@property (nonatomic, assign) NSInteger rotateBezierIndex;

@property (nonatomic, assign) CGPoint   translateLinearVariation;
@property (nonatomic, assign) NSArray  *translateBezierVariations;
@property (nonatomic, assign) NSInteger translateBezierIndex;

@property (nonatomic, assign) CGPoint   scaleLinearVariation;
@property (nonatomic, assign) NSArray  *scaleBezierVariations;
@property (nonatomic, assign) NSInteger scaleBezierIndex;


- (void)reset;


- (void)arrangeTimelineForRotates:(NSArray *)aRotates setupPoseRotation:(CGFloat)aSetupPoseRotation;
- (NSDictionary *)rotateTimelineForKeyFrame:(NSUInteger)aKeyFrame;


- (void)arrangeTimelineForTranslstes:(NSArray *)aTranslates setupPoseOffset:(CGPoint)aSetupPoseOffset;
- (NSDictionary *)translateTimelineForKeyFrame:(NSUInteger)aKeyFrame;


- (void)arrangeTimelineForScales:(NSArray *)aScales;
- (NSDictionary *)scaleTimelineForKeyFrame:(NSUInteger)aKeyFrame;


@end
