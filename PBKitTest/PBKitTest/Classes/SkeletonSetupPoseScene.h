/*
 *  SkeletonSetupPoseScene.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 8. 29..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "PBScene.h"


@class Skeleton;


@interface SkeletonSetupPoseScene : PBScene


- (void)addSkeleton:(Skeleton *)aSkeleton;
- (NSArray *)skeletons;
- (void)update;


@end
