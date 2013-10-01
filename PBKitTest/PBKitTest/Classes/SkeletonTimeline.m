/*
 *  SkeletonTimeline.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 9. 11..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SkeletonTimeline.h"
#import "SkeletonDefine.h"
#import "SkeletonAnimationItem.h"


@implementation SkeletonTimeline
{
    NSMutableDictionary *mRotateTimelines;
    CGFloat              mRotateNextVariation;
    CGFloat              mRotateLinearVariation;
    CGFloat              mRotateIntervalVariation;
    NSArray             *mRotateBezierVariations;
    NSInteger            mRotateBezierIndex;
    
    NSMutableDictionary *mTranslateTimelines;
    CGPoint              mTranslateNextVariation;
    CGPoint              mTranslateLinearVariation;
    CGPoint              mTranslateIntervalVariation;
    NSArray             *mTranslateBezierVariations;
    NSInteger            mTranslateBezierIndex;
    
    NSMutableDictionary *mScaleTimelines;
    CGPoint              mScaleNextVariation;
    CGPoint              mScaleLinearVariation;
    CGPoint              mScaleIntervalVariation;
    NSArray             *mScaleBezierVariations;
    NSInteger            mScaleBezierIndex;
}


@synthesize rotateNextVariation     = mRotateNextVariation;
@synthesize rotateLinearVariation    = mRotateLinearVariation;
@synthesize rotateIntervalVariation = mRotateIntervalVariation;
@synthesize rotateBezierVariations   = mRotateBezierVariations;
@synthesize rotateBezierIndex        = mRotateBezierIndex;

@synthesize translateNextVariation     = mTranslateNextVariation;
@synthesize translateLinearVariation   = mTranslateLinearVariation;
@synthesize translateIntervalVariation = mTranslateIntervalVariation;
@synthesize translateBezierVariations  = mTranslateBezierVariations;
@synthesize translateBezierIndex       = mTranslateBezierIndex;

@synthesize scaleNextVariation        = mScaleNextVariation;
@synthesize scaleLinearVariation      = mScaleLinearVariation;
@synthesize scaleIntervalVariation    = mScaleIntervalVariation;
@synthesize scaleBezierVariations     = mScaleBezierVariations;
@synthesize scaleBezierIndex          = mScaleBezierIndex;


#pragma mark -


/*
 Bezier curve B(t) = p0 * ( 1 - t )^3 + p1 * 3 * t * ( 1 - t )^2 + p2 * 3 * t^2 * ( 1 - t ) + p3 * t^3
 t∈ [0,1]
 p0 : start (0, 0)
 p1 : control point1
 p2 : control point2
 p3 : end (1, 1)
 */
CGPoint BezierCurveFromTime(CGFloat time, CGPoint p1, CGPoint p2)
{
    CGPoint sPoint = CGPointZero;
    CGPoint p0     = CGPointZero;
    CGPoint p3     = CGPointMake(1, 1);
    
    sPoint.x = p0.x * powf(1 - time, 3) + p1.x * 3 * time * powf(1 - time, 2) + p2.x * 3 * powf(time, 2) * (1 - time) + p3.x * powf(time, 3);
    sPoint.y = p0.y * powf(1 - time, 3) + p1.y * 3 * time * powf(1 - time, 2) + p2.y * 3 * powf(time, 2) * (1 - time) + p3.y * powf(time, 3);
    
    return sPoint;
}


- (NSArray *)bezierCurves:(NSArray *)aBezierCurves frameInterval:(NSInteger)aFrameInterval
{
    CGPoint sP1 = CGPointMake([[aBezierCurves objectAtIndex:0] floatValue], [[aBezierCurves objectAtIndex:1] floatValue]);
    CGPoint sP2 = CGPointMake([[aBezierCurves objectAtIndex:2] floatValue], [[aBezierCurves objectAtIndex:3] floatValue]);
    
    NSMutableArray *sBezierVariations = [NSMutableArray array];
    for (NSInteger sFrame = 1; sFrame <= aFrameInterval; sFrame++)
    {
        CGFloat sT               = (float)sFrame / (float)aFrameInterval;
        CGPoint sBezierPoint     = BezierCurveFromTime(sT, sP1, sP2);
        CGFloat sPower           = sBezierPoint.y;
        [sBezierVariations addObject:[NSNumber numberWithFloat:sPower]];
    }
    
    return sBezierVariations;
}


#pragma mark -


- (void)reset
{
    [mRotateTimelines removeAllObjects];
    mRotateLinearVariation  = 0;
    mRotateBezierVariations = nil;
    mRotateBezierIndex      = 0;
    
    [mTranslateTimelines removeAllObjects];
    mTranslateLinearVariation  = CGPointZero;
    mTranslateBezierVariations = nil;
    mTranslateBezierIndex      = 0;
    
    [mScaleTimelines removeAllObjects];
    mScaleLinearVariation  = CGPointZero;
    mScaleBezierVariations = nil;
    mScaleBezierIndex      = 0;
}


#pragma mark - Rotate


- (void)arrangeTimelineForRotates:(NSArray *)aRotates setupPoseRotation:(CGFloat)aSetupPoseRotation
{
    for (NSUInteger i = 0; i < [aRotates count]; i++)
    {
        if ([aRotates count] <= 1)
        {
            NSAssert(aRotates, @"Exception - Rotate Timeline");
        }
        
        if ([aRotates count] <= i + 1)
        {
            break;
        }
        
        SkeletonAnimationItem *sKeyFrameItem     = [aRotates objectAtIndex:i];
        SkeletonAnimationItem *sNextKeyFrameItem = [aRotates objectAtIndex:i + 1];
        
        CGFloat sAngle              = aSetupPoseRotation + [sKeyFrameItem angle];
        CGFloat sNextAngle          = aSetupPoseRotation + [sNextKeyFrameItem angle];
        CGFloat sNormalizeAngle     = PBNormalizeDegree(sAngle);
        CGFloat sNormalizeNextAngle = PBNormalizeDegree(sNextAngle);
        CGFloat sAngleIntervalA     = (sAngle - sNextAngle);
        CGFloat sAngleIntervalB     = (sNormalizeAngle - sNormalizeNextAngle);
        
        NSUInteger sFrameInterval   = [sNextKeyFrameItem keyFrame] - [sKeyFrameItem keyFrame];
        CGFloat    sAngleInterval   = (fmin(fabs(sAngleIntervalA), fabs(sAngleIntervalB)) == fabs(sAngleIntervalA)) ? sAngleIntervalA : sAngleIntervalB;
        CGFloat    sLinearVariation = sAngleInterval / sFrameInterval;

        NSArray *sBezierVariations  = nil;
        if ([sKeyFrameItem curveType] == kAnimationCurveBezier)
        {
            sBezierVariations = [self bezierCurves:[sKeyFrameItem bezierCurves] frameInterval:sFrameInterval];
        }

        NSDictionary *sTimelineVariation = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithFloat:sAngle], kSkeletonTimelineRotate,
                                            [NSNumber numberWithFloat:sLinearVariation], kSkeletonTimelineLinearVariation,
                                            [NSNumber numberWithFloat:sAngleInterval], kSkeletonTimelineIntervalVariation,
                                            sBezierVariations, kSkeletonTimelineBezierVariations,
                                            nil];
        [mRotateTimelines setObject:sTimelineVariation forKey:[NSNumber numberWithUnsignedInteger:[sKeyFrameItem keyFrame]]];
    }
}


- (NSDictionary *)rotateTimelineForKeyFrame:(NSUInteger)aKeyFrame
{
    return [mRotateTimelines objectForKey:[NSNumber numberWithUnsignedInteger:aKeyFrame]];
}


#pragma mark - Translate


- (void)arrangeTimelineForTranslstes:(NSArray *)aTranslates setupPoseOffset:(CGPoint)aSetupPoseOffset
{
    for (NSUInteger i = 0; i < [aTranslates count]; i++)
    {
        if ([aTranslates count] <= 1)
        {
            NSAssert(aTranslates, @"Exception - Translate Timeline");
        }
        
        if ([aTranslates count] <= i + 1)
        {
            break;
        }
        
        SkeletonAnimationItem *sKeyFrameItem     = [aTranslates objectAtIndex:i];
        SkeletonAnimationItem *sNextKeyFrameItem = [aTranslates objectAtIndex:i + 1];
        
        CGPoint sTranslate          = CGPointZero;
        CGPoint sNextTranslate      = CGPointZero;
        CGPoint sPointInterval      = CGPointZero;
        
        sTranslate.x                = aSetupPoseOffset.x + [sKeyFrameItem translate].x;
        sTranslate.y                = aSetupPoseOffset.y + [sKeyFrameItem translate].y;
        sNextTranslate.x            = aSetupPoseOffset.x + [sNextKeyFrameItem translate].x;
        sNextTranslate.y            = aSetupPoseOffset.y + [sNextKeyFrameItem translate].y;
        
        sPointInterval              = CGPointMake((sNextTranslate.x) - (sTranslate.x), (sNextTranslate.y) - (sTranslate.y));
        
        NSUInteger sFrameInterval   = [sNextKeyFrameItem keyFrame] - [sKeyFrameItem keyFrame];
        CGPoint    sLinearVariation = CGPointMake(sPointInterval.x / sFrameInterval, sPointInterval.y / sFrameInterval);
        
        NSArray *sBezierVariations  = nil;
        if ([sKeyFrameItem curveType] == kAnimationCurveBezier)
        {
            sBezierVariations = [self bezierCurves:[sKeyFrameItem bezierCurves] frameInterval:sFrameInterval];
        }
        
        NSDictionary *sTimelineVariation = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSValue valueWithCGPoint:sTranslate], kSkeletonTimelineTranslate,
                                            [NSValue valueWithCGPoint:sLinearVariation], kSkeletonTimelineLinearVariation,
                                            [NSValue valueWithCGPoint:sPointInterval], kSkeletonTimelineIntervalVariation,
                                            sBezierVariations, kSkeletonTimelineBezierVariations,
                                            nil];
        
        [mTranslateTimelines setObject:sTimelineVariation forKey:[NSNumber numberWithUnsignedInteger:[sKeyFrameItem keyFrame]]];
    }
}


- (NSDictionary *)translateTimelineForKeyFrame:(NSUInteger)aKeyFrame
{
    return [mTranslateTimelines objectForKey:[NSNumber numberWithUnsignedInteger:aKeyFrame]];
}


#pragma mark - Scale


- (void)arrangeTimelineForScales:(NSArray *)aScales
{
    for (NSUInteger i = 0; i < [aScales count]; i++)
    {
        
        if ([aScales count] <= 1)
        {
            NSAssert(aScales, @"Exception - scale Timeline");
        }
        
        if ([aScales count] <= i + 1)
        {
            break;
        }
        
        SkeletonAnimationItem *sKeyFrameItem     = [aScales objectAtIndex:i];
        SkeletonAnimationItem *sNextKeyFrameItem = [aScales objectAtIndex:i + 1];

        CGPoint sScale              = CGPointMake([sKeyFrameItem scale].x, [sKeyFrameItem scale].y);
        CGPoint sNextScale          = CGPointMake([sNextKeyFrameItem scale].x, [sNextKeyFrameItem scale].y);
        CGPoint sScaleInterval      = CGPointMake((sNextScale.x) - (sScale.x), (sNextScale.y) - (sScale.y));
        
        NSUInteger sFrameInterval   = [sNextKeyFrameItem keyFrame] - [sKeyFrameItem keyFrame];
        CGPoint    sLinearVariation = CGPointMake(sScaleInterval.x / sFrameInterval, sScaleInterval.y / sFrameInterval);
        
        NSArray *sBezierVariations  = nil;
        if ([sKeyFrameItem curveType] == kAnimationCurveBezier)
        {
            sBezierVariations = [self bezierCurves:[sKeyFrameItem bezierCurves] frameInterval:sFrameInterval];
        }
        
        NSDictionary *sTimelineVariation = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSValue valueWithCGPoint:sScale], kSkeletonTimelineScale,
                                            [NSValue valueWithCGPoint:sLinearVariation], kSkeletonTimelineLinearVariation,
                                            [NSValue valueWithCGPoint:sScaleInterval], kSkeletonTimelineIntervalVariation,
                                            sBezierVariations, kSkeletonTimelineBezierVariations,
                                            nil];
        
        [mScaleTimelines setObject:sTimelineVariation forKey:[NSNumber numberWithUnsignedInteger:[sKeyFrameItem keyFrame]]];
    }
}


- (NSDictionary *)scaleTimelineForKeyFrame:(NSUInteger)aKeyFrame
{
    return [mScaleTimelines objectForKey:[NSNumber numberWithUnsignedInteger:aKeyFrame]];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mRotateTimelines    = [[NSMutableDictionary alloc] init];
        mTranslateTimelines = [[NSMutableDictionary alloc] init];
        mScaleTimelines     = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mRotateTimelines release];
    [mTranslateTimelines release];
    [mScaleTimelines release];
    
    [super dealloc];
}


@end
