/*
 *  SkeletonAnimationBone.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 9. 10..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBKit.h>
#import <Foundation/Foundation.h>


typedef enum
{
    kAnimationTimelineTypeRotate    = 1,
    kAnimationTimelineTypeTranslate = 2,
    kAnimationTimelineTypeScale     = 3,
} SkeletonAnimationTimelineType;


typedef enum
{
    kAnimationCurveLinear           = 0,
    kAnimationCurveStepped          = 1,
    kAnimationCurveBezier           = 2,
} SkeletonAnimationCurveType;


@interface SkeletonAnimationBone : NSObject


@property (nonatomic, readonly) NSString                     *name;
@property (nonatomic, readonly) SkeletonAnimationTimelineType type;
// Common bone keyframe attributes
@property (nonatomic, readonly) NSString                     *time;
@property (nonatomic, readonly) SkeletonAnimationCurveType    curveType;
@property (nonatomic, readonly) NSArray                      *bezierCurves;
// Translate keyframe attributes
@property (nonatomic, readonly) CGPoint                       translate;
// Scale keyframe attributes
@property (nonatomic, readonly) CGPoint                       scale;
// Rotate keyframe attributes
@property (nonatomic, readonly) CGFloat                       angle;

@property (nonatomic, readonly) NSUInteger                    keyFrame;


- (id)initWithBoneName:(NSString *)aBoneName timelineData:(NSDictionary *)aTimelineData type:(SkeletonAnimationTimelineType)aType;


@end
