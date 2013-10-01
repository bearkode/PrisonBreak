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
#import "SkeletonAnimation.h"
#import "SkeletonTimeline.h"


static CGFloat const kBoneShapeHeight = 5.0f;


@implementation SkeletonBone
{
    NSString            *mName;
    NSString            *mParentName;
    CGFloat              mLength;
    CGFloat              mSetupPoseAngle;
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
    if (mAnimationTestType == kAnimationTestTypeAll || mAnimationTestType == kAnimationTestTypeRotate)
    {
        CGFloat sAngle = [mTimeline rotateForFrame:aFrame];
        [mNode setAngle:PBVertex3Make(0, 0, sAngle)];
    }
}


- (void)animateTranslateForFrame:(NSUInteger)aFrame
{
    if (mAnimationTestType == kAnimationTestTypeAll || mAnimationTestType == kAnimationTestTypeTranslate)
    {
        CGPoint sPoint = [mTimeline translateForFrame:aFrame];
        [mNode setPoint:sPoint];
    }
}


- (void)animateScaleForFrame:(NSUInteger)aFrame
{
    if (mAnimationTestType == kAnimationTestTypeAll || mAnimationTestType == kAnimationTestTypeScale)
    {
        CGPoint sScale = [mTimeline scaleForFrame:aFrame];
        [mNode setScale:PBVertex3Make(sScale.x, sScale.y, 1.0f)];
    }
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
    [aSkinNode setAngle:PBVertex3Make(0, 0, 360.0f - [aSkinItem angle])];
    [mNode addSubNode:aSkinNode];
}


- (void)arrangeAnimation:(SkeletonAnimation *)aAnimation
{
    NSDictionary *sBoneAnimation = [aAnimation animationForBoneName:mName];
    [mTimeline reset];
    [mTimeline setTotalFrame:[aAnimation totalFrame]];

    [mTimeline arrangeTimelineForRotates:[sBoneAnimation objectForKey:kSkeletonRotate] setupPoseAngle:mSetupPoseAngle];
    [mTimeline arrangeTimelineForTranslstes:[sBoneAnimation objectForKey:kSkeletonTranslate] setupPoseOffset:mSetupPoseOffset];
    [mTimeline arrangeTimelineForScales:[sBoneAnimation objectForKey:kSkeletonScale] setupPoseScale:mSetupPoseScale];
}


#pragma mark -


- (void)actionSetupPose
{
    [mNode setPoint:mSetupPoseOffset];
    [mNode setAngle:PBVertex3Make(0, 0, 360.0f - mSetupPoseAngle)];
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
        mName            = [[aBoneData objectForKey:kSkeletonName] retain];
        mParentName      = [[aBoneData objectForKey:kSkeletonParent] retain];
        mLength          = [[aBoneData objectForKey:kSkeletonLength] floatValue];
        mSetupPoseAngle  = [[aBoneData objectForKey:kSkeletonRotation] floatValue];
        mSetupPoseOffset = CGPointMake([[aBoneData objectForKey:kSkeletonX] floatValue], [[aBoneData objectForKey:kSkeletonY] floatValue]);
        mSetupPoseScale  = CGPointMake(1.0f, 1.0f);
        if ([aBoneData objectForKey:kSkeletonScaleX])
        {
            mSetupPoseScale.x = [[aBoneData objectForKey:kSkeletonScaleX] floatValue];
        }
        if ([aBoneData objectForKey:kSkeletonScaleY])
        {
            mSetupPoseScale.y = [[aBoneData objectForKey:kSkeletonScaleY] floatValue];
        }
        
        mTimeline = [[SkeletonTimeline alloc] init];
        mNode     = [[PBNode alloc] init];
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
