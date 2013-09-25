/*
 *  SkeletonSlot.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 8. 29..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SkeletonSlot.h"
#import "SkeletonDefine.h"


@implementation SkeletonSlot
{
    NSString *mName;
    NSString *mBoneName;
    NSString *mAttachment;
}


@synthesize name       = mName;
@synthesize boneName   = mBoneName;
@synthesize attachment = mAttachment;



#pragma mark -


- (id)initWithSlotData:(NSDictionary *)aSlotData
{
    self = [super init];
    if (self)
    {
        mName       = [[aSlotData objectForKey:kSkeletonName] retain];
        mBoneName   = [[aSlotData objectForKey:kSkeletonKeyBone] retain];
        mAttachment = [[aSlotData objectForKey:kSkeletonAttachment] retain];
    }
    
    return self;
}


- (void)dealloc
{
    [mName release];
    [mBoneName release];
    [mAttachment release];
    
    [super dealloc];
}


@end
