/*
 *  Skeleton.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 8. 29..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "Skeleton.h"
#import "SkeletonBone.h"
#import "SkeletonSlot.h"
#import "SkeletonSkin.h"
#import "SkeletonSkinItem.h"
#import "SkeletonAnimation.h"


@implementation Skeleton
{
    NSMutableArray      *mSlots;
    NSMutableArray      *mBones;
    NSMutableDictionary *mBonesDict;
    NSMutableDictionary *mSkins;
    NSMutableDictionary *mAnimations;

    PBNode              *mLayer;
    NSString            *mEquipSkin;
    SkeletonAnimation   *mCurrentAnimation;
    NSUInteger           mCurrentFrame;
    CGFloat              mCurrentTime;
    
    SkeletonActionMode   mActionMode;
}


@synthesize currentFrame = mCurrentFrame;
@synthesize currentTime  = mCurrentTime;
@synthesize equipSkin    = mEquipSkin;


#pragma mark -


- (void)extractBonesWithSkeletonObject:(NSDictionary *)aSkeletonObject
{
    NSArray *sBones = [aSkeletonObject objectForKey:kSkeletonKeyBones];
    for (NSDictionary *sBoneData in sBones)
    {
        SkeletonBone *sBone       = [[[SkeletonBone alloc] initWithBoneData:sBoneData] autorelease];
        SkeletonBone *sParentBone = [self boneForName:[sBone parentName]];
        if (!sParentBone && ![[sBone name] isEqualToString:kBoneKeyRoot])
        {
            NSLog(@"exception");
        }
        [sBone setParentBone:sParentBone];
        [mBones addObject:sBone];
        [mBonesDict setObject:sBone forKey:[sBone name]];
    }
}


- (void)extractSlotsWithSkeletonObject:(NSDictionary *)aSkeletonObject
{
    NSArray *sSlots = [aSkeletonObject objectForKey:kSkeletonKeySlots];
    for (NSDictionary *sSlotData in sSlots)
    {
        SkeletonSlot *sSlot = [[[SkeletonSlot alloc] initWithSlotData:sSlotData] autorelease];
        [mSlots addObject:sSlot];
    }
}


- (void)extractSkinsWithSkeletonObject:(NSDictionary *)aSkeletonObject
{
    NSDictionary *sSkins = [aSkeletonObject objectForKey:kSkeletonKeySkins];
    [sSkins enumerateKeysAndObjectsUsingBlock:^(NSString *aSkinName, NSDictionary *aSkinData, BOOL *aStop) {
        SkeletonSkin *sSkin = [[[SkeletonSkin alloc] initWithSkinName:aSkinName data:aSkinData] autorelease];
        [mSkins setObject:sSkin forKey:aSkinName];
    }];
}


- (void)extractAnimationsWithSkeletonObject:(NSDictionary *)aSkeletonObject
{
    NSDictionary *sAnimations = [aSkeletonObject objectForKey:kSkeletonKeyAnimations];
    [sAnimations enumerateKeysAndObjectsUsingBlock:^(NSString *aAnimationName, NSDictionary *aAnimationData, BOOL *aStop) {
        // will remove
        // jump left foot 의 4번째 인가.. time 의 소숫점..
        SkeletonAnimation *sAnimation = [[[SkeletonAnimation alloc] initWithAnimationName:aAnimationName data:aAnimationData] autorelease];
        [mAnimations setObject:sAnimation forKey:aAnimationName];
    }];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mSlots      = [[NSMutableArray alloc] init];
        mBones      = [[NSMutableArray alloc] init];
        mBonesDict  = [[NSMutableDictionary alloc] init];
        mSkins      = [[NSMutableDictionary alloc] init];
        mAnimations = [[NSMutableDictionary alloc] init];
        
        mLayer      = [[PBNode alloc] init];
        [mLayer setProjectionPackEnabled:YES];
        
        mActionMode = kActionModeNone;
    }
    
    return self;
}


- (void)dealloc
{
    [mCurrentAnimation release];
    [mEquipSkin release];
    [mLayer release];
    [mSlots release];
    [mBones release];
    [mBonesDict release];
    [mSkins release];
    [mAnimations release];
    
    [super dealloc];
}


#pragma mark -


- (void)loadSpineJsonFilename:(NSString *)aFilename
{
    NSError      *sError          = nil;
    NSData       *sSpineJsonData  = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:aFilename ofType:@"json"]];
    NSDictionary *sSkeletonObject = [NSJSONSerialization JSONObjectWithData:sSpineJsonData options:kNilOptions error:&sError];
    if (sError)
    {
        NSLog(@"Error occured\n%@", sError);
    }
//    NSLog(@"%@", sSkeletonObject);
    
    [self extractBonesWithSkeletonObject:sSkeletonObject];
    [self extractSlotsWithSkeletonObject:sSkeletonObject];
    [self extractSkinsWithSkeletonObject:sSkeletonObject];
    [self extractAnimationsWithSkeletonObject:sSkeletonObject];
}


- (void)arrange
{
    mActionMode   = kActionModeNone;
    mCurrentFrame = 0;
    
    for (SkeletonBone *sBone in mBones)
    {
        [sBone arrangeBone];
    }
    [mLayer addSubNode:[[self boneForName:kBoneKeyRoot] node]];
    
    // draw skin
    SkeletonSkin *sEquippedSkin = [mSkins objectForKey:mEquipSkin];
    for (NSInteger sOrder = 0; sOrder < [mSlots count]; sOrder++)
    {
        SkeletonSlot     *sSlot     = [mSlots objectAtIndex:sOrder];
        SkeletonBone     *sBone     = [self boneForName:[sSlot boneName]];
        SkeletonSkinItem *sSkinItem = [sEquippedSkin skinItemForAttachmentName:[sSlot attachment]];
        PBAtlasNode      *sSkinNode = [sEquippedSkin atlasNodeForKey:[sSlot attachment]];
        [sSkinNode setProjectionPackOrder:sOrder];
        [sBone arrangeSkinNode:sSkinNode skinItem:sSkinItem];
    }
}


- (void)actionSetupPose
{
    mActionMode   = kActionModeSetupPose;
    mCurrentFrame = 0;

    for (SkeletonBone *sBone in mBones)
    {
        [sBone actionSetupPose];
    }
}


- (void)actionAnimation:(NSString *)aAnimation
{
    [self actionSetupPose];

    mActionMode   = kActionModeAnimate;
    mCurrentFrame = 0;

    [mCurrentAnimation autorelease];
    mCurrentAnimation = [[mAnimations objectForKey:aAnimation] retain];
    for (SkeletonBone *sBone in mBones)
    {
        NSDictionary *sBoneAnimation = [mCurrentAnimation animationForBoneName:[sBone name]];
        [sBone arrangeAnimation:sBoneAnimation];
    }
}


#pragma mark - Bone


- (PBNode *)layer
{
    return mLayer;
}


- (NSArray *)bones
{
    return mBones;
}


- (SkeletonBone *)boneForName:(NSString *)aBoneName
{
    return [mBonesDict objectForKey:aBoneName];
}


- (void)setHiddenBone:(BOOL)aHidden
{
    for (SkeletonBone *sBone in mBones)
    {
        [[sBone node] setHidden:aHidden];
    }
}


#pragma mark - Skin


- (NSDictionary *)skins
{
    return mSkins;
}

- (SkeletonSkin *)skinForName:(NSString *)aSkinName
{
    return [mSkins objectForKey:aSkinName];
}


#pragma mark - Slot


- (NSArray *)slots
{
    return mSlots;
}


#pragma mark -


- (void)update
{
    switch (mActionMode)
    {
        case kActionModeSetupPose:
            break;
        case kActionModeAnimate:
        {
            if (mCurrentFrame > [mCurrentAnimation totalFrame])
            {
                mCurrentFrame = 0;
            }

            for (SkeletonBone *sBone in mBones)
            {
                [sBone actionAnimateForFrame:mCurrentFrame];
            }

            mCurrentFrame++;
            mCurrentTime = (CGFloat)mCurrentFrame / kSkeletonFramelate;
        }
            break;
        default:
            break;
    }
}


#pragma mark - For debugging


- (void)setFrame:(NSUInteger)aFrame
{
    mCurrentFrame = aFrame;
}


- (void)setAnimationTestType:(SkeletonAnimationTestType)aType
{
    for (SkeletonBone *sBone in mBones)
    {
        [sBone setAnimationTestType:aType];
    }
}


@end
