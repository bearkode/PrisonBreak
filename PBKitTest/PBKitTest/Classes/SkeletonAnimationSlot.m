/*
 *  SkeletonAnimationSlot.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 10. 10..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SkeletonAnimationSlot.h"
#import "SkeletonDefine.h"


@implementation SkeletonAnimationSlot
{
    NSString  *mBoneName;
    NSString  *mAttachmentName;
    NSString  *mTime;
    NSUInteger mKeyFrame;
}


@synthesize boneName       = mBoneName;
@synthesize attachmentName = mAttachmentName;
@synthesize time           = mTime;
@synthesize keyFrame       = mKeyFrame;


- (id)initWithBoneName:(NSString *)aBoneName timelineData:(NSDictionary *)aTimelineData
{
    self = [super init];
    if (self)
    {
        mBoneName       = [aBoneName retain];
        mAttachmentName = [[aTimelineData objectForKey:kSkeletonName] retain];
        mTime           = [[aTimelineData objectForKey:kSkeletonTime] retain];
        
        mKeyFrame       = ConvertKeyframeFromTime(mTime);
    }
    
    return self;
}


- (void)dealloc
{
    [mBoneName release];
    [mAttachmentName release];
    
    [super dealloc];
}


@end
