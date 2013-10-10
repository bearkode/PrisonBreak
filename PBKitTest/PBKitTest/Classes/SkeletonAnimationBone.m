/*
 *  SkeletonAnimationBone.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 9. 10..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SkeletonAnimationBone.h"
#import "SkeletonDefine.h"


@implementation SkeletonAnimationBone
{
    NSString                     *mName;
    SkeletonAnimationTimelineType mType;
    NSString                     *mTime;
    SkeletonAnimationCurveType    mCurveType;
    NSArray                      *mBezierCurves;
    CGPoint                       mTranslate;
    CGPoint                       mScale;
    CGFloat                       mAngle;
    
    NSUInteger                    mKeyFrame;
}


@synthesize name         = mName;
@synthesize type         = mType;
@synthesize time         = mTime;
@synthesize curveType    = mCurveType;
@synthesize bezierCurves = mBezierCurves;
@synthesize translate    = mTranslate;
@synthesize scale        = mScale;
@synthesize angle        = mAngle;
@synthesize keyFrame     = mKeyFrame;


#pragma mark -


- (id)initWithBoneName:(NSString *)aBoneName timelineData:(NSDictionary *)aTimelineData type:(SkeletonAnimationTimelineType)aType
{
    self = [super init];
    if (self)
    {
//        NSLog(@"%@", aBoneName);
//        NSLog(@"%@", aTimelineData);

        mType     = aType;
        mName     = [aBoneName retain];
        mTime     = [[aTimelineData objectForKey:kSkeletonTime] retain];
        
        id sCurve = [aTimelineData objectForKey:kSkeletonCurve];
        if (sCurve)
        {
            if ([sCurve isKindOfClass:[NSArray class]])
            {
                mBezierCurves = [sCurve retain];
                mCurveType    = kAnimationCurveBezier;
            }
            else
            {
                mCurveType = kAnimationCurveStepped;
            }
        }
        else
        {
            mCurveType = kAnimationCurveLinear;
        }
        
        mKeyFrame = ConvertKeyframeFromTime(mTime);
        switch (mType)
        {
            case kAnimationTimelineTypeRotate:
                mAngle = [[aTimelineData objectForKey:kSkeletonAngle] floatValue];
                break;
            case kAnimationTimelineTypeTranslate:
                mTranslate = CGPointMake([[aTimelineData objectForKey:kSkeletonX] floatValue], [[aTimelineData objectForKey:kSkeletonY] floatValue]);
                break;
            case kAnimationTimelineTypeScale:
                mScale = CGPointMake([[aTimelineData objectForKey:kSkeletonX] floatValue], [[aTimelineData objectForKey:kSkeletonY] floatValue]);
                break;
            default:
                break;
        }
    }
    
    return self;
}


- (void)dealloc
{
    [mName release];
    [mTime release];
    [mBezierCurves release];
    
    [super dealloc];
}


@end
