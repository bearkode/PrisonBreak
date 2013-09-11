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
- (void)arrange;


#pragma mark - action


- (void)actionSetupPose;
- (void)actionAnimation:(NSString *)aAnimation;


- (PBNode *)layer;


#pragma mark - bone

- (NSArray *)bones;
- (SkeletonBone *)boneForName:(NSString *)aParentBoneName;
- (void)setHiddenBone:(BOOL)aHidden;


#pragma mark - skin

- (NSDictionary *)skins;
- (SkeletonSkin *)skinForName:(NSString *)aSkinName;


- (NSArray *)slots;


#pragma mark - update


- (void)update;


// debug
- (void)setFrame:(NSUInteger)aFrame;


@end
