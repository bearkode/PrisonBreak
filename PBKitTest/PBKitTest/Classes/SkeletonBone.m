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
#import "SkeletonAnimationBone.h"
#import "SkeletonAnimationSlot.h"
#import "SkeletonAnimation.h"
#import "SkeletonTimeline.h"


//static CGFloat const kBoneShapeHeight = 5.0f;


@implementation SkeletonBone
{
    NSString         *mName;
    NSString         *mParentName;
    CGFloat           mLength;
    CGFloat           mSetupPoseAngle;
    CGPoint           mSetupPoseOffset;
    CGPoint           mSetupPoseScale;
    
    PBNode           *mNode;
    PBAtlasNode      *mSetupPoseNode;
    PBAtlasNode      *mCurrentNode;
    SkeletonBone     *mParentBone;
    SkeletonTimeline *mTimeline;

    SkeletonTestType mTestType;
}


@synthesize name        = mName;
@synthesize parentName  = mParentName;
@synthesize parentBone  = mParentBone;

@synthesize testType = mTestType;


#pragma mark -


- (void)animateRotateForFrame:(NSUInteger)aFrame
{
    if (mTestType == kAnimationTestTypeAll || mTestType == kAnimationTestTypeRotate)
    {
        CGFloat sAngle = [mTimeline rotateForFrame:aFrame];
        [mNode setAngle:PBVertex3Make(0, 0, sAngle)];
    }
}


- (void)animateTranslateForFrame:(NSUInteger)aFrame
{
    if (mTestType == kAnimationTestTypeAll || mTestType == kAnimationTestTypeTranslate)
    {
        CGPoint sPoint = [mTimeline translateForFrame:aFrame];
        [mNode setPoint:sPoint];
    }
}


- (void)animateScaleForFrame:(NSUInteger)aFrame
{
    if (mTestType == kAnimationTestTypeAll || mTestType == kAnimationTestTypeScale)
    {
        CGPoint sScale = [mTimeline scaleForFrame:aFrame];
        [mNode setScale:PBVertex3Make(sScale.x, sScale.y, 1.0f)];
    }
}


- (void)animateSlotForFrame:(NSUInteger)aFrame
{
    PBAtlasNode *sAttachmentNode = [mTimeline slotForFrame:aFrame];
    if (sAttachmentNode)
    {
        [sAttachmentNode setPoint:[mCurrentNode point]];
        [sAttachmentNode setAngle:[mCurrentNode angle]];
        [sAttachmentNode setScale:[mCurrentNode scale]];
        [sAttachmentNode setProjectionPackOrder:[mCurrentNode projectionPackOrder]];
        
        [mCurrentNode removeFromSuperNode];
        [mNode addSubNode:sAttachmentNode];
        
        mCurrentNode = sAttachmentNode;
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
    [mSetupPoseNode autorelease];
    mSetupPoseNode = [aSkinNode retain];
    [aSkinNode setPoint:[aSkinItem offset]];
    [aSkinNode setAngle:PBVertex3Make(0, 0, 360.0f - [aSkinItem angle])];
    [mNode addSubNode:mSetupPoseNode];
    mCurrentNode = mSetupPoseNode;
}


- (void)arrangeAnimation:(SkeletonAnimation *)aAnimation equipSkin:(SkeletonSkin *)aEquippedSkin
{
    NSDictionary *sBoneAnimation = [aAnimation animationForBoneName:mName];
    [mTimeline reset];
    [mTimeline setTotalFrame:[aAnimation totalFrame]];

    [mTimeline arrangeTimelineForRotates:[sBoneAnimation objectForKey:kSkeletonRotate] setupPoseAngle:mSetupPoseAngle];
    [mTimeline arrangeTimelineForTranslstes:[sBoneAnimation objectForKey:kSkeletonTranslate] setupPoseOffset:mSetupPoseOffset];
    [mTimeline arrangeTimelineForScales:[sBoneAnimation objectForKey:kSkeletonScale] setupPoseScale:mSetupPoseScale];
    [mTimeline arrangeTimelineForSlots:[aAnimation animationForSlotName:mName] equipSkin:aEquippedSkin];
}


#pragma mark -


- (void)actionSetupPose
{
    [mNode setPoint:mSetupPoseOffset];
    [mNode setAngle:PBVertex3Make(0, 0, 360.0f - mSetupPoseAngle)];
    [mNode setScale:PBVertex3Make(mSetupPoseScale.x, mSetupPoseScale.y, 1.0f)];

    if (mCurrentNode != mSetupPoseNode)
    {
        [mCurrentNode removeFromSuperNode];
        [mNode addSubNode:mSetupPoseNode];
        mCurrentNode = mSetupPoseNode;
    }
}


- (void)actionAnimateForFrame:(NSUInteger)aFrame
{
    [self animateRotateForFrame:aFrame];
    [self animateTranslateForFrame:aFrame];
    [self animateScaleForFrame:aFrame];
    [self animateSlotForFrame:aFrame];
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
        [mNode setHidden:YES];
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
    [mSetupPoseNode release];
    [mTimeline release];
    [mName release];
    [mParentName release];
    [mParentBone release];
    [mNode release];
    
    [super dealloc];
}


@end
