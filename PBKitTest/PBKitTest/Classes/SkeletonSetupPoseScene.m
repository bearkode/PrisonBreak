/*
 *  SkeletonSetupPoseScene.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 8. 29..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SkeletonSetupPoseScene.h"
#import <PBKit.h>
#import "Skeleton.h"
#import "SkeletonBone.h"
#import "SkeletonSkin.h"


@implementation SkeletonSetupPoseScene
{
    NSMutableArray *mSkeletons;
}


#pragma mark -


- (void)addSkeleton:(Skeleton *)aSkeleton
{
    [mSkeletons addObject:aSkeleton];
    [self addSubNode:[aSkeleton layer]];
}


- (NSArray *)skeletons
{
    return mSkeletons;
}


- (void)update
{
    for (Skeleton *sSkeleton in mSkeletons)
    {
        [sSkeleton update];
    }
}


#pragma mark -


- (id)initWithDelegate:(id)aDelegate
{
    self = [super initWithDelegate:aDelegate];
    if (self)
    {
        mSkeletons = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (id)init
{
    return [self initWithDelegate:nil];
}


- (void)dealloc
{
    [mSkeletons release];

    [super dealloc];
}


@end
