/*
 *  BoneAnimationViewController.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 8. 29..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "BoneAnimationViewController.h"
#import "ProfilingOverlay.h"
#import "Skeleton.h"
#import "SkeletonSetupPoseScene.h"

#define USE_RENDER_REPORT 1
#if (USE_RENDER_REPORT)
#import <PBRenderTestReport.h>
#endif


#define kSkeletonNameSpineBoy @"spineboy"
#define kSkeletonNameSpitMan  @"spitman"


@implementation BoneAnimationViewController
{
    SkeletonSetupPoseScene *mScene;
    NSInteger               mSkeletonCount;
    PBVertex3               mSkeletonScale;
    
    
    /* For UI */
    UISegmentedControl      *mActionSegment;
    UISegmentedControl      *mAnimationSegment;
    NSInteger                mSelectedBoneIndex;
}


#pragma mark -


- (void)addSkeleton
{
    switch (mSelectedBoneIndex)
    {
        case 1:
            [self addSkeletonWithFilename:kSkeletonNameSpineBoy skinname:@"default"];
            break;
        case 2:
            [self addSkeletonWithFilename:kSkeletonNameSpitMan skinname:@"default"];
            break;
        default:
            return;
    }
}


- (void)addSkeletonWithFilename:(NSString *)aFilename skinname:(NSString *)aSkinname
{
    mSkeletonCount++;
    
    Skeleton *sSkeleton = [[[Skeleton alloc] init] autorelease];
    [sSkeleton loadSpineJsonFilename:aFilename];
    [sSkeleton setEquipSkin:aSkinname];
    [sSkeleton generate];
    [sSkeleton actionSetupPose];
    [mScene addSkeleton:sSkeleton];

    if (mSkeletonCount <= 1)
    {
        [[sSkeleton node] setPoint:CGPointMake(0, -100)];
    }
    else
    {
        CGPoint sPoint = CGPointMake(arc4random() % 100, arc4random() % 100);
        if (arc4random() % 2) sPoint.x *= -1;
        if (arc4random() % 2) sPoint.y *= -1;
        if (mSkeletonCount % 2) {
            mSkeletonScale.x -= 0.01f;
            mSkeletonScale.y -= 0.01f;
        }
        if (mSkeletonScale.x < 0 || mSkeletonScale.y < 0){
            mSkeletonScale = PBVertex3Make(1.0, 1.0, 1.0);
        }
        [[sSkeleton node] setPoint:sPoint];
    }
    [[sSkeleton node] setScale:mSkeletonScale];
}


#pragma mark -


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[self view] setBackgroundColor:[UIColor darkGrayColor]];
    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    [mScene release];
    
    [super dealloc];
}


- (void)viewWillAppear:(BOOL)aAnimated
{
    UIAlertView *sAlert = [[[UIAlertView alloc] initWithTitle:@"Select Bone" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil] autorelease];
    [sAlert addButtonWithTitle:kSkeletonNameSpineBoy];
    [sAlert addButtonWithTitle:kSkeletonNameSpitMan];
    [sAlert show];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mScene = [[SkeletonSetupPoseScene alloc] initWithDelegate:self];
    [[self canvas] presentScene:mScene];

    PBSpriteNode *sBGNode = [PBSpriteNode spriteNodeWithImageNamed:@"bone_bg"];
    [mScene addSubNode:sBGNode];
    
    PBRenderTesting(true);
    
    mSkeletonScale = PBVertex3Make(0.25f, 0.25f, 1.0f);
    
    UIBarButtonItem *sAddSkeletonButton = [[[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(addSkeleton)] autorelease];
    [[self navigationItem] setRightBarButtonItem:sAddSkeletonButton];
}


#pragma mark -


- (void)alertView:(UIAlertView *)aAlertView clickedButtonAtIndex:(NSInteger)aButtonIndex
{
    NSArray *sSegments = nil;
    mSelectedBoneIndex = aButtonIndex;
    switch (mSelectedBoneIndex)
    {
        case 1:
            sSegments = [NSArray arrayWithObjects:@"SetupPose", @"Walk", @"Jump",  nil];
            [self addSkeletonWithFilename:kSkeletonNameSpineBoy skinname:@"default"];
            break;
        case 2:
            sSegments = [NSArray arrayWithObjects:@"SetupPose", @"Walk", @"Attack", nil];
            [self addSkeletonWithFilename:kSkeletonNameSpitMan skinname:@"default"];
            break;
        case 0: // Cancel
        default:
            [[self navigationController] setNavigationBarHidden:NO];
            [[self navigationController] popViewControllerAnimated:YES];
            return;
    }
    
    CGRect sFrame = [[self view] frame];
    mActionSegment = [[[UISegmentedControl alloc]initWithItems:sSegments] autorelease];
    [mActionSegment setFrame:CGRectMake((sFrame.size.width - 300) / 2.0, sFrame.size.height - 85, 300, 30)];
    [mActionSegment addTarget:self action:@selector(actionSelected:)forControlEvents:UIControlEventValueChanged];
    [mActionSegment setSelectedSegmentIndex:0];
    [mActionSegment setSegmentedControlStyle:UISegmentedControlStyleBar];
    [[self view] addSubview:mActionSegment];
    
    mAnimationSegment = [[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"All", @"Rotate", @"Translate", @"Scale",  nil]] autorelease];
    [mAnimationSegment setFrame:CGRectMake((sFrame.size.width - 300) / 2.0, sFrame.size.height - 50, 300, 30)];
    [mAnimationSegment addTarget:self action:@selector(animateSelected:)forControlEvents:UIControlEventValueChanged];
    [mAnimationSegment setSelectedSegmentIndex:0];
    [mAnimationSegment setSegmentedControlStyle:UISegmentedControlStyleBar];
    [mAnimationSegment setEnabled:NO];
    [[self view] addSubview:mAnimationSegment];
}


- (IBAction)actionSelected:(UISegmentedControl *)aSender
{
    switch ([aSender selectedSegmentIndex])
    {
        case 0: // setuppose
            for (Skeleton *sSkeleton in [mScene skeletons])
            {
                [sSkeleton actionSetupPose];
            }
            [mAnimationSegment setEnabled:NO];
            break;
        case 1: // walk
        {
            for (Skeleton *sSkeleton in [mScene skeletons])
            {
                [sSkeleton actionAnimation:@"walk"];
            }
            [mAnimationSegment setEnabled:YES];
        }
            break;
        case 2: // action
        {
            for (Skeleton *sSkeleton in [mScene skeletons])
            {
                NSString *sActionName = (mSelectedBoneIndex == 1) ? @"jump" : @"attack";
                [sSkeleton actionAnimation:sActionName];
            }
            [mAnimationSegment setEnabled:YES];
        }
            break;
        default:
            break;
    }
}


- (IBAction)animateSelected:(UISegmentedControl *)aSender
{
    switch ([aSender selectedSegmentIndex])
    {
        case 0: // all
            for (Skeleton *sSkeleton in [mScene skeletons])
            {
                [sSkeleton setAnimationTestType:kAnimationTestTypeAll];
            }
            break;
        case 1: // rotate
        {
            for (Skeleton *sSkeleton in [mScene skeletons])
            {
                [sSkeleton setAnimationTestType:kAnimationTestTypeRotate];
            }
        }
            break;
        case 2: // translate
        {
            for (Skeleton *sSkeleton in [mScene skeletons])
            {
                [sSkeleton setAnimationTestType:kAnimationTestTypeTranslate];
            }
        }
            break;
        case 3: // scale
        {
            for (Skeleton *sSkeleton in [mScene skeletons])
            {
                [sSkeleton setAnimationTestType:kAnimationTestTypeScale];
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark -


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
//    [[ProfilingOverlay sharedManager] displayFPS:[[self canvas] fps] timeInterval:[[self canvas] timeInterval]];
    [mScene update];
    
    [self setTitle:[NSString stringWithFormat:@"glDraw %d",PBRenderReport().testDrawCallCount]];
    
//    for (Skeleton *sSkeleton in [mScene skeletons])
//    {
//        [self setTitle:[NSString stringWithFormat:@"(F %d) D = %d", (NSUInteger)[sSkeleton currentFrame], PBRenderReport().testDrawCallCount]];
//    }
}


@end
