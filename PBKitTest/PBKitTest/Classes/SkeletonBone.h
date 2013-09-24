/*
 *  SkeletonBone.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 8. 29..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>
#import <PBKit.h>
#import "SkeletonDefine.h"


@class SkeletonSkinItem;


@interface SkeletonBone : NSObject


@property (nonatomic, readonly) NSString     *name;
@property (nonatomic, readonly) NSString     *parentName;
@property (nonatomic, retain)   SkeletonBone *parentBone;

@property (nonatomic, assign)   SkeletonAnimationTestType animationTestType;


- (id)initWithBoneData:(NSDictionary *)aBoneData;


- (PBNode *)node;


- (void)arrangeBone;
- (void)arrangeSkinNode:(PBAtlasNode *)aSkinNode skinItem:(SkeletonSkinItem *)aSkinItem;
- (void)arrangeAnimation:(NSDictionary *)aAnimation;


- (void)actionSetupPose;
- (void)actionAnimateForFrame:(NSUInteger)aFrame;


@end
