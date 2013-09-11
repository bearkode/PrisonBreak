/*
 *  SkeletonBone.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 8. 29..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SkeletonBone.h"
#import "SkeletonDefine.h"
#import "SkeletonSkinItem.h"
#import "SkeletonAnimationItem.h"
#import "SkeletonTimeline.h"


static CGFloat const kBoneShapeHeight = 5.0f;


@implementation SkeletonBone
{
    NSString            *mName;
    NSString            *mParentName;
    CGFloat              mLength;
    CGFloat              mRotation;
    CGPoint              mOffset;
    CGFloat              mSetupPoseRotation;
    CGPoint              mSetupPoseOffset;
    
    PBNode              *mNode;
    SkeletonBone        *mParentBone;
    
    SkeletonTimeline    *mTimeline;
}


@synthesize name        = mName;
@synthesize parentName  = mParentName;
@synthesize parentBone  = mParentBone;


#pragma mark -


- (void)arrangeAnimationForRotates:(NSArray *)aRotates
{
    for (NSUInteger i = 0; i < [aRotates count]; i++)
    {
        if ([aRotates count] <= 1)
        {
            NSAssert(aRotates, @"Exception - Rotate Timeline");
        }
        
        SkeletonAnimationItem *sKeyFrameItem     = [aRotates objectAtIndex:i];
        if ([aRotates count] <= i + 1)
        {
            break;
        }
        
        SkeletonAnimationItem *sNextKeyFrameItem = [aRotates objectAtIndex:i + 1];
        
        CGFloat sAngle              = mSetupPoseRotation + [sKeyFrameItem angle];
        CGFloat sNextAngle          = mSetupPoseRotation + [sNextKeyFrameItem angle];
        CGFloat sNormalizeAngle     = PBNormalizeDegree(sAngle);
        CGFloat sNormalizeNextAngle = PBNormalizeDegree(sNextAngle);
        CGFloat sAngleIntervalA     = (sAngle - sNextAngle);
        CGFloat sAngleIntervalB     = (sNormalizeAngle - sNormalizeNextAngle);

        NSUInteger sFrameInterval   = [sNextKeyFrameItem keyFrame] - [sKeyFrameItem keyFrame];
        CGFloat    sAngleInterval   = (fmin(fabs(sAngleIntervalA), fabs(sAngleIntervalB)) == fabs(sAngleIntervalA)) ? sAngleIntervalA : sAngleIntervalB;
        CGFloat    sAngleVariation  = sAngleInterval / sFrameInterval;
        
        [mTimeline setRotateAngle:sAngle angleVariation:sAngleVariation forKeyFrame:[sKeyFrameItem keyFrame]];
    }
}


- (void)animateRotationForFrame:(NSUInteger)aFrame
{
    NSDictionary *sTimelineVariation = [mTimeline rotateTimelineForKeyFrame:aFrame];
    if (sTimelineVariation)
    {
        CGFloat sAngle      = [[sTimelineVariation objectForKey:@"angle"] floatValue];
        [mNode setAngle:PBVertex3Make(0, 0, 360.0f - sAngle)];
        [mTimeline setRotateVariation:[[sTimelineVariation objectForKey:@"angleVariation"] floatValue]];
    }
    else
    {
        [mNode setAngle:PBVertex3Make(0, 0, PBNormalizeDegree([mNode angle].z + [mTimeline rotateVariation]))];
    }
}


#pragma mark -


- (PBNode *)node
{
    return mNode;
}


- (void)resetNode
{
    [mTimeline setRotateVariation:0];
    [mNode setPoint:CGPointZero];
    [mNode setAngle:PBVertex3Zero];
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
    // arrange rotate
    [mTimeline reset];
    NSArray *sRotates  = [aAnimation objectForKey:kSkeletonRotate];
    [self arrangeAnimationForRotates:sRotates];
    
    // arrange translate
    
//    NSArray *sTranslates = [aAnimation objectForKey:kSkeletonTranslate];
//    NSArray *sScales     = [aAnimation objectForKey:kSkeletonScale];
    
}


#pragma mark -


- (void)actionSetupPose
{
    [mNode setPoint:mSetupPoseOffset];
    [mNode setAngle:PBVertex3Make(0, 0, 360.0f - mSetupPoseRotation)];
}


- (void)actionAnimateForFrame:(NSUInteger)aFrame
{
    // animate rotation timeline
    [self animateRotationForFrame:aFrame];
    
    [mNode setPoint:mOffset];
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
        mRotation          = [[aBoneData objectForKey:kSkeletonRotation] floatValue];
        mOffset            = CGPointMake([[aBoneData objectForKey:kSkeletonX] floatValue], [[aBoneData objectForKey:kSkeletonY] floatValue]);
        mSetupPoseRotation = mRotation;
        mSetupPoseOffset   = mOffset;
        
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
