/*
 *  SkeletonBone.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 8. 29..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SkeletonBone.h"
#import "SkeletonSkinItem.h"
#import "SkeletonAnimationItem.h"
#import "SkeletonTimeline.h"


static CGFloat const kBoneShapeHeight = 5.0f;


@implementation SkeletonBone
{
    NSString            *mName;
    NSString            *mParentName;
    CGFloat              mLength;
    CGFloat              mSetupPoseRotation;
    CGPoint              mSetupPoseOffset;
    CGPoint              mSetupPoseScale;
    
    PBNode              *mNode;
    SkeletonBone        *mParentBone;
    
    SkeletonTimeline    *mTimeline;
    
    
    SkeletonAnimationTestType mAnimationTestType;
}


@synthesize name        = mName;
@synthesize parentName  = mParentName;
@synthesize parentBone  = mParentBone;

@synthesize animationTestType = mAnimationTestType;


#pragma mark -


- (void)animateRotateForFrame:(NSUInteger)aFrame
{
    CGFloat sAngle = 0.0f;
    NSDictionary *sTimelineVariation = [mTimeline rotateTimelineForKeyFrame:aFrame];
    if (sTimelineVariation)
    {
        CGFloat  sRotateAngle      = [[sTimelineVariation objectForKey:kSkeletonTimelineRotate] floatValue];
        sAngle = 360.0f - sRotateAngle;

        NSArray *sBezierVariations = [sTimelineVariation objectForKey:kSkeletonTimelineBezierVariations];
        [mTimeline setRotateLinearVariation:[[sTimelineVariation objectForKey:kSkeletonTimelineLinearVariation] floatValue]];
        [mTimeline setRotateBezierVariations:sBezierVariations];
        [mTimeline setRotateBezierIndex:0];
    }
    else
    {
        CGFloat  sRotateVariation  = [mTimeline rotateLinearVariation];
        CGFloat  sLinearVariation  = [mTimeline rotateLinearVariation];
        NSArray *sBezierVariations = [mTimeline rotateBezierVariations];
        if (sBezierVariations)
        {
            NSInteger sBezierIndex     = [mTimeline rotateBezierIndex];
            CGFloat   sBezierVariation = [[sBezierVariations objectAtIndex:sBezierIndex] floatValue];

            sRotateVariation = sLinearVariation - sBezierVariation;
            [mTimeline setRotateBezierIndex:++sBezierIndex];
        }
        
        sAngle = PBNormalizeDegree([mNode angle].z + sRotateVariation);
    }
    
    if (mAnimationTestType == kAnimationTestTypeAll || mAnimationTestType == kAnimationTestTypeRotate)
    {
        [mNode setAngle:PBVertex3Make(0, 0, sAngle)];
    }
}


- (void)animateTranslateForFrame:(NSUInteger)aFrame
{
    CGPoint       sPoint = CGPointZero;
    NSDictionary *sTimelineVariation = [mTimeline translateTimelineForKeyFrame:aFrame];
    if (sTimelineVariation)
    {
        sPoint                     = [[sTimelineVariation objectForKey:kSkeletonTimelineTranslate] CGPointValue];

        NSArray *sBezierVariations = [sTimelineVariation objectForKey:kSkeletonTimelineBezierVariations];
        [mTimeline setTranslateLinearVariation:[[sTimelineVariation objectForKey:kSkeletonTimelineLinearVariation] CGPointValue]];
        [mTimeline setTranslateBezierVariations:sBezierVariations];
        [mTimeline setTranslateBezierIndex:0];
    }
    else
    {
        sPoint    = [mNode point];
        sPoint.x += [mTimeline translateLinearVariation].x;
        sPoint.y += [mTimeline translateLinearVariation].y;

        NSArray *sBezierVariations = [mTimeline translateBezierVariations];
        if (sBezierVariations)
        {
            NSInteger sBezierIndex     = [mTimeline translateBezierIndex];
            CGFloat   sBezierVariation = [[sBezierVariations objectAtIndex:sBezierIndex] floatValue];
            
            sPoint.x -= sBezierVariation;
            sPoint.y -= sBezierVariation;
            [mTimeline setTranslateBezierIndex:++sBezierIndex];
        }
    }

    if (mAnimationTestType == kAnimationTestTypeAll || mAnimationTestType == kAnimationTestTypeTranslate)
    {
        [mNode setPoint:sPoint];
    }
}


- (void)animateScaleForFrame:(NSUInteger)aFrame
{
    PBVertex3       sScale             = PBVertex3Make(1.0f, 1.0f, 1.0f);
    NSDictionary *sTimelineVariation = [mTimeline scaleTimelineForKeyFrame:aFrame];
    if (sTimelineVariation)
    {
        CGPoint sScaleOffset = [[sTimelineVariation objectForKey:kSkeletonTimelineScale] CGPointValue];
        sScale = PBVertex3Make(sScaleOffset.x, sScaleOffset.y, 1.0f);

        NSArray *sBezierVariations = [sTimelineVariation objectForKey:kSkeletonTimelineBezierVariations];
        [mTimeline setScaleLinearVariation:[[sTimelineVariation objectForKey:kSkeletonTimelineLinearVariation] CGPointValue]];
        [mTimeline setScaleBezierVariations:sBezierVariations];
        [mTimeline setScaleBezierIndex:0];
    }
    else
    {
        sScale.x = [mNode scale].x + [mTimeline scaleLinearVariation].x;
        sScale.y = [mNode scale].y + [mTimeline scaleLinearVariation].y;
        
        NSArray *sBezierVariations = [mTimeline scaleBezierVariations];
        if (sBezierVariations)
        {
            NSInteger sBezierIndex     = [mTimeline scaleBezierIndex];
            CGFloat   sBezierVariation = [[sBezierVariations objectAtIndex:sBezierIndex] floatValue];
            
            sScale.x -= sBezierVariation;
            sScale.y -= sBezierVariation;
            [mTimeline setScaleBezierIndex:++sBezierIndex];
        }
    }

    [mNode setScale:sScale];
}


#pragma mark -


- (PBNode *)node
{
    return mNode;
}


#pragma mark -


- (void)arrangeBone
{
    [[[self parentBone] node] addSubNode:mNode];
}


- (void)arrangeSkinNode:(PBAtlasNode *)aSkinNode skinItem:(SkeletonSkinItem *)aSkinItem
{
    [aSkinNode setPoint:[aSkinItem offset]];
    [aSkinNode setAngle:PBVertex3Make(0, 0, 360.0f - [aSkinItem rotation])];
    [mNode addSubNode:aSkinNode];
}


- (void)arrangeAnimation:(NSDictionary *)aAnimation
{
    [mTimeline reset];

    [mTimeline arrangeTimelineForRotates:[aAnimation objectForKey:kSkeletonRotate] setupPoseRotation:mSetupPoseRotation];
    [mTimeline arrangeTimelineForTranslstes:[aAnimation objectForKey:kSkeletonTranslate] setupPoseOffset:mSetupPoseOffset];
    [mTimeline arrangeTimelineForScales:[aAnimation objectForKey:kSkeletonScale]];
}


#pragma mark -


- (void)actionSetupPose
{
    [mNode setPoint:mSetupPoseOffset];
    [mNode setAngle:PBVertex3Make(0, 0, 360.0f - mSetupPoseRotation)];
    [mNode setScale:PBVertex3Make(mSetupPoseScale.x, mSetupPoseScale.y, 1.0f)];
}


- (void)actionAnimateForFrame:(NSUInteger)aFrame
{
    [self animateRotateForFrame:aFrame];
    [self animateTranslateForFrame:aFrame];
    [self animateScaleForFrame:aFrame];
}


#pragma mark -


- (id)initWithBoneData:(NSDictionary *)aBoneData
{
    self = [super init];
    if (self)
    {
        mName              = [[aBoneData objectForKey:kSkeletonName] retain];
        mParentName        = [[aBoneData objectForKey:kSkeletonParent] retain];
        mLength            = [[aBoneData objectForKey:kSkeletonLength] floatValue];
        mSetupPoseRotation = [[aBoneData objectForKey:kSkeletonRotation] floatValue];
        mSetupPoseOffset   = CGPointMake([[aBoneData objectForKey:kSkeletonX] floatValue], [[aBoneData objectForKey:kSkeletonY] floatValue]);
        mSetupPoseScale    = CGPointMake(1.0f, 1.0f);
        if ([aBoneData objectForKey:kSkeletonScaleX])
        {
            mSetupPoseScale.x = [[aBoneData objectForKey:kSkeletonScaleX] floatValue];
        }
        if ([aBoneData objectForKey:kSkeletonScaleY])
        {
            mSetupPoseScale.y = [[aBoneData objectForKey:kSkeletonScaleY] floatValue];
        }
        
        mTimeline          = [[SkeletonTimeline alloc] init];
        mNode              = [[PBNode alloc] init];
    }
    
    return self;
}


- (void)setParentBone:(SkeletonBone *)aParentBone
{
    [mParentBone autorelease];
    mParentBone = [aParentBone retain];
}


- (void)dealloc
{
    [mTimeline release];
    [mName release];
    [mParentName release];
    [mParentBone release];
    [mNode release];
    
    [super dealloc];
}


@end
