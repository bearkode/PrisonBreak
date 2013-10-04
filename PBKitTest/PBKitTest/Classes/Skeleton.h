/*
 *  Skeleton.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 8. 29..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>
#import <PBKit.h>
#import "SkeletonDefine.h"


typedef enum
{
    kActionModeNone      = 0,
    kActionModeSetupPose = 1,
    kActionModeAnimate   = 2,
} SkeletonActionMode;


@class SkeletonBone;
@class SkeletonSkin;


@interface Skeleton : NSObject


@property (nonatomic, readonly) NSUInteger currentFrame;
@property (nonatomic, readonly) CGFloat    currentTime;
@property (nonatomic, retain)   NSString  *equipSkin;


#pragma mark -


- (void)loadSpineJsonFilename:(NSString *)aFilename;
- (void)generate;


#pragma mark - node


- (PBNode *)node;


#pragma mark - action


- (void)actionSetupPose;
- (void)actionAnimation:(NSString *)aAnimation;


#pragma mark - update


- (void)update;


/* For debugging */
- (void)setFrame:(NSUInteger)aFrame;
- (void)setAnimationTestType:(SkeletonAnimationTestType)aType;


@end
