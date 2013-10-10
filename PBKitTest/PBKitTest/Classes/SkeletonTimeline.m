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
    NSMutableArray *mRotateTimelines;
    NSMutableArray *mTranslateTimelines;
    NSMutableArray *mScaleTimelines;
    NSUInteger      mTotalFrame;
}


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


#pragma mark - arrange rotate


- (NSDictionary *)arrangeKeyFrameForRotates:(NSArray *)aRotates setupPoseAngle:(CGFloat)aSetupPoseAngle
{
    NSMutableDictionary *sRotateTimelines = [NSMutableDictionary dictionary];
    
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
        
        CGFloat   sAngle              = aSetupPoseAngle + [sKeyFrameItem angle];
        CGFloat   sNextAngle          = aSetupPoseAngle + [sNextKeyFrameItem angle];
        CGFloat   sNormalizeAngle     = PBNormalizeDegree(sAngle);
        CGFloat   sNormalizeNextAngle = PBNormalizeDegree(sNextAngle);
        CGFloat   sAngleIntervalA     = (sAngle - sNextAngle);
        CGFloat   sAngleIntervalB     = (sNormalizeAngle - sNormalizeNextAngle);
        
        NSInteger sFrameInterval      = [sNextKeyFrameItem keyFrame] - [sKeyFrameItem keyFrame];
        CGFloat   sAngleInterval      = (fmin(fabs(sAngleIntervalA), fabs(sAngleIntervalB)) == fabs(sAngleIntervalA)) ? sAngleIntervalA : sAngleIntervalB;
        CGFloat   sLinearVariation    = sAngleInterval / sFrameInterval;
        
        NSArray *sBezierVariations     = nil;
        if ([sKeyFrameItem curveType] == kAnimationCurveBezier)
        {
            sBezierVariations = [self bezierCurves:[sKeyFrameItem bezierCurves] frameInterval:sFrameInterval];
        }
        
        NSDictionary *sTimelineVariation = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithFloat:sAngle], kSkeletonTimelineRotate,
                                            [NSNumber numberWithFloat:sLinearVariation], kSkeletonTimelineLinearVariation,
                                            [NSNumber numberWithFloat:sAngleInterval], kSkeletonTimelineIntervalVariation,
                                            [NSNumber numberWithInteger:sFrameInterval], kSkeletonTimelineIntervalCount,
                                            sBezierVariations, kSkeletonTimelineBezierVariations,
                                            nil];
        [sRotateTimelines setObject:sTimelineVariation forKey:[NSNumber numberWithUnsignedInteger:[sKeyFrameItem keyFrame]]];
    }
    
    return sRotateTimelines;
}


- (void)generateRotateTimeline:(NSDictionary *)aKeyFrames setupPoseAngle:(CGFloat)aSetupPoseAngle
{
    CGFloat   sAngle             = aSetupPoseAngle;
    CGFloat   sKeyFrameAngle     = 0.0f;
    CGFloat   sLinearVariation   = 0.0f;
    CGFloat   sIntervalVariation = 0.0f;
    NSInteger sIntervalCount     = 0;
    NSInteger sBezierIndex       = 0;
    NSArray  *sBezierVariations  = nil;
    
    for (NSUInteger sFrame = 0; sFrame < mTotalFrame; sFrame++)
    {
        CGFloat sArrangedAngle = 0.0f;
        NSDictionary *sKeyFrameVariation = [aKeyFrames objectForKey:[NSNumber numberWithUnsignedInteger:sFrame]];
        if (sKeyFrameVariation)
        {
            sKeyFrameAngle     = [[sKeyFrameVariation objectForKey:kSkeletonTimelineRotate] floatValue];
            sLinearVariation   = [[sKeyFrameVariation objectForKey:kSkeletonTimelineLinearVariation] floatValue];
            sIntervalVariation = [[sKeyFrameVariation objectForKey:kSkeletonTimelineIntervalVariation] floatValue];
            sIntervalCount     = [[sKeyFrameVariation objectForKey:kSkeletonTimelineIntervalCount] integerValue];
            sBezierVariations  = [sKeyFrameVariation objectForKey:kSkeletonTimelineBezierVariations];
            sBezierIndex       = 0;
            sAngle             = PBNormalizeDegree(360.0f - sKeyFrameAngle);
            sArrangedAngle     = sAngle;
        }
        else
        {
            if (sIntervalCount > 0)
            {
                if (sBezierVariations)
                {
                    CGFloat sBezierVariation = [[sBezierVariations objectAtIndex:sBezierIndex] floatValue];
                    sAngle = PBNormalizeDegree((360.0f - sKeyFrameAngle) + (sIntervalVariation * sBezierVariation));
                    sBezierIndex++;
                }
                else
                {
                    sAngle = PBNormalizeDegree(sAngle + sLinearVariation);
                }
                
                sArrangedAngle = sAngle;
                sIntervalCount--;
            }
            else
            {
                sArrangedAngle = PBNormalizeDegree(360.0f - PBNormalizeDegree(sAngle));
            }
        }
        
        [mRotateTimelines addObject:[NSNumber numberWithFloat:sArrangedAngle]];
    }
}


#pragma mark - arrange translate


- (NSDictionary *)arrangeKeyFrameForTranslates:(NSArray *)aTranslates setupPoseOffset:(CGPoint)aSetupPoseOffset
{
    NSMutableDictionary *sTranslateTimelines = [NSMutableDictionary dictionary];
    
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
        
        CGPoint    sTranslate       = CGPointMake(aSetupPoseOffset.x + [sKeyFrameItem translate].x, aSetupPoseOffset.y + [sKeyFrameItem translate].y);
        CGPoint    sNextTranslate   = CGPointMake(aSetupPoseOffset.x + [sNextKeyFrameItem translate].x, aSetupPoseOffset.y + [sNextKeyFrameItem translate].y);
        CGPoint    sPointInterval   = CGPointMake((sNextTranslate.x) - (sTranslate.x), (sNextTranslate.y) - (sTranslate.y));
        
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
        
        [sTranslateTimelines setObject:sTimelineVariation forKey:[NSNumber numberWithUnsignedInteger:[sKeyFrameItem keyFrame]]];
    }
    
    return sTranslateTimelines;
}


- (void)generateTranslateTimeline:(NSDictionary *)aKeyFrames setupPoseOffset:(CGPoint)aSetupPoseOffset
{
    CGPoint   sPoint             = aSetupPoseOffset;
    CGPoint   sKeyFramePoint     = CGPointZero;
    CGPoint   sLinearVariation   = CGPointZero;
    CGPoint   sIntervalVariation = CGPointZero;
    NSInteger sBezierIndex       = 0;
    NSArray  *sBezierVariations  = nil;
    
    for (NSUInteger sFrame = 0; sFrame < mTotalFrame; sFrame++)
    {
        NSDictionary *sKeyFrameVariation = [aKeyFrames objectForKey:[NSNumber numberWithUnsignedInteger:sFrame]];
        if (sKeyFrameVariation)
        {
            sKeyFramePoint     = [[sKeyFrameVariation objectForKey:kSkeletonTimelineTranslate] CGPointValue];
            sLinearVariation   = [[sKeyFrameVariation objectForKey:kSkeletonTimelineLinearVariation] CGPointValue];
            sIntervalVariation = [[sKeyFrameVariation objectForKey:kSkeletonTimelineIntervalVariation] CGPointValue];
            sBezierVariations  = [sKeyFrameVariation objectForKey:kSkeletonTimelineBezierVariations];
            sBezierIndex       = 0;
            sPoint             = sKeyFramePoint;
        }
        else
        {
            if (sBezierVariations)
            {
                CGFloat sBezierVariation = [[sBezierVariations objectAtIndex:sBezierIndex] floatValue];
                sPoint.x = sKeyFramePoint.x + (sIntervalVariation.x * sBezierVariation);
                sPoint.y = sKeyFramePoint.y + (sIntervalVariation.y * sBezierVariation);
                sBezierIndex++;
            }
            else
            {
                sPoint.x += sLinearVariation.x;
                sPoint.y += sLinearVariation.y;
            }
        }
        
        [mTranslateTimelines addObject:[NSValue valueWithCGPoint:sPoint]];
    }
}


#pragma mark - arrange scale


- (NSDictionary *)arrangeKeyFrameForScales:(NSArray *)aScales setupPoseScale:(CGPoint)aSetupPoseScale
{
    NSMutableDictionary *sScaleTimelines = [NSMutableDictionary dictionary];
    
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
        
        CGPoint sScale              = CGPointMake(aSetupPoseScale.x * [sKeyFrameItem scale].x, aSetupPoseScale.y * [sKeyFrameItem scale].y);
        CGPoint sNextScale          = CGPointMake(aSetupPoseScale.x * [sNextKeyFrameItem scale].x, aSetupPoseScale.y * [sNextKeyFrameItem scale].y);
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
        
        [sScaleTimelines setObject:sTimelineVariation forKey:[NSNumber numberWithUnsignedInteger:[sKeyFrameItem keyFrame]]];
    }

    return sScaleTimelines;
}


- (void)generateScaleTimeline:(NSDictionary *)aKeyFrames setupPoseScale:(CGPoint)aSetupPoseScale
{

    CGPoint   sScale             = aSetupPoseScale;
    CGPoint   sKeyFrameScale     = CGPointZero;
    CGPoint   sLinearVariation   = CGPointZero;
    CGPoint   sIntervalVariation = CGPointZero;
    NSInteger sBezierIndex       = 0;
    NSArray  *sBezierVariations  = nil;
    
    for (NSUInteger sFrame = 0; sFrame < mTotalFrame; sFrame++)
    {
        NSDictionary *sKeyFrameVariation = [aKeyFrames objectForKey:[NSNumber numberWithUnsignedInteger:sFrame]];
        
        if (sKeyFrameVariation)
        {
            sKeyFrameScale     = [[sKeyFrameVariation objectForKey:kSkeletonTimelineScale] CGPointValue];
            sLinearVariation   = [[sKeyFrameVariation objectForKey:kSkeletonTimelineLinearVariation] CGPointValue];
            sIntervalVariation = [[sKeyFrameVariation objectForKey:kSkeletonTimelineIntervalVariation] CGPointValue];
            sBezierVariations  = [sKeyFrameVariation objectForKey:kSkeletonTimelineBezierVariations];
            sBezierIndex       = 0;
            sScale             = sKeyFrameScale;
        }
        else
        {
            if (sBezierVariations)
            {
                CGFloat sBezierVariation = [[sBezierVariations objectAtIndex:sBezierIndex] floatValue];
                sScale.x = sKeyFrameScale.x + (sIntervalVariation.x * sBezierVariation);
                sScale.y = sKeyFrameScale.y + (sIntervalVariation.y * sBezierVariation);
                sBezierIndex++;
            }
            else
            {
                sScale.x += sLinearVariation.x;
                sScale.y += sLinearVariation.y;
            }
        }
        
        [mScaleTimelines addObject:[NSValue valueWithCGPoint:sScale]];
    }
}


#pragma mark -


- (void)reset
{
    [mRotateTimelines removeAllObjects];
    [mTranslateTimelines removeAllObjects];
    [mScaleTimelines removeAllObjects];
}


- (void)setTotalFrame:(NSUInteger)aTotalFrame
{
    mTotalFrame = aTotalFrame;
}


#pragma mark - Rotate


- (void)arrangeTimelineForRotates:(NSArray *)aRotates setupPoseAngle:(CGFloat)aSetupPoseAngle
{
    [mRotateTimelines removeAllObjects];
    NSDictionary *sKeyFrames = [self arrangeKeyFrameForRotates:aRotates setupPoseAngle:aSetupPoseAngle];
    [self generateRotateTimeline:sKeyFrames setupPoseAngle:aSetupPoseAngle];
}


- (CGFloat)rotateForFrame:(NSUInteger)aFrame
{
    if (aFrame > [mRotateTimelines count])
    {
        NSAssert(NO, @"exception rotate timeline");
    }
    
    return [[mRotateTimelines objectAtIndex:aFrame] floatValue];
}


#pragma mark - Translate


- (void)arrangeTimelineForTranslstes:(NSArray *)aTranslates setupPoseOffset:(CGPoint)aSetupPoseOffset
{
    [mTranslateTimelines removeAllObjects];
    NSDictionary *sKeyFrames = [self arrangeKeyFrameForTranslates:aTranslates setupPoseOffset:aSetupPoseOffset];
    [self generateTranslateTimeline:sKeyFrames setupPoseOffset:aSetupPoseOffset];
}


- (CGPoint)translateForFrame:(NSUInteger)aFrame
{
    if (aFrame > [mTranslateTimelines count])
    {
        NSAssert(NO, @"exception translate timeline");
    }
    
    return [[mTranslateTimelines objectAtIndex:aFrame] CGPointValue];
}


#pragma mark - Scale


- (void)arrangeTimelineForScales:(NSArray *)aScales setupPoseScale:(CGPoint)aSetupPoseScale
{
    [mScaleTimelines removeAllObjects];
    NSDictionary *sKeyFrames = [self arrangeKeyFrameForScales:aScales setupPoseScale:aSetupPoseScale];
    [self generateScaleTimeline:sKeyFrames setupPoseScale:aSetupPoseScale];
}


- (CGPoint)scaleForFrame:(NSUInteger)aFrame
{
    if (aFrame > [mScaleTimelines count])
    {
        NSAssert(NO, @"exception scale timeline");
    }
    
    return [[mScaleTimelines objectAtIndex:aFrame] CGPointValue];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mRotateTimelines    = [[NSMutableArray alloc] init];
        mTranslateTimelines = [[NSMutableArray alloc] init];
        mScaleTimelines     = [[NSMutableArray alloc] init];
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
