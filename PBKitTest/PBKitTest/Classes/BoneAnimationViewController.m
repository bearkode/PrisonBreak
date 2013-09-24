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



@implementation BoneAnimationViewController
{
    SkeletonSetupPoseScene *mScene;
    NSInteger               mSkeletonCount;
    PBVertex3               mSkeletonScale;
    
    
    /* For UI */
    UISegmentedControl      *mActionSegment;
    UISegmentedControl      *mAnimationSegment;
}


#pragma mark -


- (void)addSkeleton
{
    mSkeletonCount++;
    
    Skeleton *sSkeleton = [[[Skeleton alloc] init] autorelease];
    [sSkeleton loadSpineJsonFilename:@"spineboy"];
    [sSkeleton setHiddenBone:YES];
    [sSkeleton setEquipSkin:@"default"];
    [sSkeleton arrange];
    [sSkeleton actionSetupPose];
    [mScene addSkeleton:sSkeleton];

    if (mSkeletonCount <= 1)
    {
        [[sSkeleton layer] setPoint:CGPointMake(0, -150)];
    }
    else
    {
        CGPoint sPoint = CGPointMake(arc4random() % 100, arc4random() % 100);
        if (arc4random() % 2) sPoint.x *= -1;
        if (arc4random() % 2) sPoint.y *= -1;
        if (mSkeletonCount % 2) {
            mSkeletonScale.x -= 0.05f;
            mSkeletonScale.y -= 0.05f;
        }
        if (mSkeletonScale.x < 0 || mSkeletonScale.y < 0){
            mSkeletonScale = PBVertex3Make(1.0, 1.0, 1.0);
        }
        [[sSkeleton layer] setPoint:sPoint];
    }
    [[sSkeleton layer] setScale:mSkeletonScale];
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mScene = [[SkeletonSetupPoseScene alloc] initWithDelegate:self];
    [[self canvas] presentScene:mScene];

    PBSpriteNode *sBGNode = [PBSpriteNode spriteNodeWithImageNamed:@"bone_bg"];
    [mScene addSubNode:sBGNode];
    
    PBRenderTesting(true);
    
    mSkeletonScale = PBVertex3Make(1.0f, 1.0f, 1.0f);
    [self addSkeleton];
    
//    UIBarButtonItem *sAddSkeletonButton = [[[UIBarButtonItem alloc] initWithTitle:@"Add"
//                                                                            style:UIBarButtonItemStylePlain
//                                                                           target:self
//                                                                           action:@selector(addSkeleton)] autorelease];
//    [[self navigationItem] setRightBarButtonItem:sAddSkeletonButton];
    
    
    CGRect sFrame = [[self view] frame];
    mActionSegment = [[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"SetupPose", @"Walk", @"Jump",  nil]] autorelease];
    [mActionSegment setFrame:CGRectMake((sFrame.size.width - 300) / 2.0, sFrame.size.height - 115, 300, 30)];
    [mActionSegment addTarget:self action:@selector(actionSelected:)forControlEvents:UIControlEventValueChanged];
    [mActionSegment setSelectedSegmentIndex:0];
    [mActionSegment setSegmentedControlStyle:UISegmentedControlStyleBar];
    [[self view] addSubview:mActionSegment];
    
    mAnimationSegment = [[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"All", @"Rotate", @"Translate", @"Scale",  nil]] autorelease];
    [mAnimationSegment setFrame:CGRectMake((sFrame.size.width - 300) / 2.0, sFrame.size.height - 80, 300, 30)];
    [mAnimationSegment addTarget:self action:@selector(animateSelected:)forControlEvents:UIControlEventValueChanged];
    [mAnimationSegment setSelectedSegmentIndex:0];
    [mAnimationSegment setSegmentedControlStyle:UISegmentedControlStyleBar];
    [mAnimationSegment setEnabled:NO];
    [[self view] addSubview:mAnimationSegment];
}


#pragma mark -


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
        case 2: // jump
        {
            for (Skeleton *sSkeleton in [mScene skeletons])
            {
                [sSkeleton actionAnimation:@"jump"];
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
