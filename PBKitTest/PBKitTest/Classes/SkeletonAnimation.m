/*
 *  SkeletonAnimation.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 9. 9..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SkeletonAnimation.h"
#import "SkeletonDefine.h"
#import "SkeletonAnimationBone.h"
#import "SkeletonAnimationSlot.h"


@implementation SkeletonAnimation
{
    NSString            *mName;
    NSMutableDictionary *mAnimationBones;
    NSMutableDictionary *mAnimationSlots;
    NSUInteger           mTotalFrame;
}


#pragma mark -


- (NSDictionary *)animationForBoneName:(NSString *)aBoneName
{
    return [mAnimationBones objectForKey:aBoneName];
}


- (NSArray *)animationForSlotName:(NSString *)aBoneName
{
    return [mAnimationSlots objectForKey:aBoneName];
}


- (NSUInteger)totalFrame
{
    return mTotalFrame;
}


#pragma mark -



- (id)initWithAnimationName:(NSString *)aAnimationName data:(NSDictionary *)aAnimationData
{
    self = [super init];
    if (self)
    {
        mName           = [aAnimationName retain];
        mAnimationBones = [[NSMutableDictionary alloc] init];
        mAnimationSlots = [[NSMutableDictionary alloc] init];
        
        [[aAnimationData objectForKey:kSkeletonKeyBones] enumerateKeysAndObjectsUsingBlock:^(NSString *aBoneName, NSDictionary *aTimelineData, BOOL *aStop) {
            NSMutableArray *sRotates    = [[[NSMutableArray alloc] init] autorelease];
            NSMutableArray *sTranslates = [[[NSMutableArray alloc] init] autorelease];
            NSMutableArray *sScales     = [[[NSMutableArray alloc] init] autorelease];
            
            for (NSDictionary *sRotate in [aTimelineData objectForKey:kSkeletonRotate])
            {
                SkeletonAnimationBone *sItem = [[[SkeletonAnimationBone alloc] initWithBoneName:aBoneName timelineData:sRotate type:kAnimationTimelineTypeRotate] autorelease];
                mTotalFrame = ([sItem keyFrame] + 1 > mTotalFrame) ? [sItem keyFrame] + 1 : mTotalFrame;
                [sRotates addObject:sItem];
            }
            
            for (NSDictionary *sTranslate in [aTimelineData objectForKey:kSkeletonTranslate])
            {
                SkeletonAnimationBone *sItem = [[[SkeletonAnimationBone alloc] initWithBoneName:aBoneName timelineData:sTranslate type:kAnimationTimelineTypeTranslate] autorelease];
                mTotalFrame = ([sItem keyFrame] + 1 > mTotalFrame) ? [sItem keyFrame] + 1 : mTotalFrame;
                [sTranslates addObject:sItem];
            }

            for (NSDictionary *sScale in [aTimelineData objectForKey:kSkeletonScale])
            {
                SkeletonAnimationBone *sItem = [[[SkeletonAnimationBone alloc] initWithBoneName:aBoneName timelineData:sScale type:kAnimationTimelineTypeScale] autorelease];
                mTotalFrame = ([sItem keyFrame] + 1 > mTotalFrame) ? [sItem keyFrame] + 1 : mTotalFrame;
                [sScales addObject:sItem];
            }
            
            NSDictionary *sAnimation = [NSDictionary dictionaryWithObjectsAndKeys:
                                        sRotates, kSkeletonRotate,
                                        sTranslates, kSkeletonTranslate,
                                        sScales, kSkeletonScale,
                                        nil];
            [mAnimationBones setObject:sAnimation forKey:aBoneName];
        }];
        
        
        [[aAnimationData objectForKey:kSkeletonKeySlots] enumerateKeysAndObjectsUsingBlock:^(NSString *aBoneName, NSDictionary *aTimelineData, BOOL *aStop) {
            NSMutableArray *sAttachments = [[[NSMutableArray alloc] init] autorelease];
            for (NSDictionary *sAttachment in [aTimelineData objectForKey:kSkeletonAttachment])
            {
                SkeletonAnimationSlot *sItem = [[[SkeletonAnimationSlot alloc] initWithBoneName:aBoneName timelineData:sAttachment] autorelease];
                [sAttachments addObject:sItem];
            }
            [mAnimationSlots setObject:sAttachments forKey:aBoneName];
        }];
    }
    
    return self;
}


- (void)dealloc
{
    [mName release];
    [mAnimationBones release];
    [mAnimationSlots release];
    
    [super dealloc];
}


@end
