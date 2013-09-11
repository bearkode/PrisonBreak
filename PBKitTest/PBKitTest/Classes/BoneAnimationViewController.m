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

    [[sSkeleton layer] setPoint:CGPointMake(0, -150)];

//    CGPoint sPoint = CGPointMake(arc4random() % 100, arc4random() % 100);
//    if (arc4random() % 2) sPoint.x *= -1;
//    if (arc4random() % 2) sPoint.y *= -1;
//    [[sSkeleton layer] setPoint:sPoint];
//    [[sSkeleton layer] setScale:0.5];
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
    
    [self addSkeleton];
    
    UIBarButtonItem *sAddSkeletonButton = [[[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(addSkeleton)] autorelease];
    [[self navigationItem] setRightBarButtonItem:sAddSkeletonButton];
    
    
    CGRect sFrame = [[self view] frame];
    UISegmentedControl *mActionSegment = [[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"SetupPose", @"Walk", @"Jump",  nil]] autorelease];
    [mActionSegment setFrame:CGRectMake((sFrame.size.width - 300) / 2.0, sFrame.size.height - 80, 300, 30)];
    [mActionSegment addTarget:self action:@selector(actionSelected:)forControlEvents:UIControlEventValueChanged];
    [mActionSegment setSelectedSegmentIndex:0];
    [mActionSegment setSegmentedControlStyle:UISegmentedControlStyleBar];
    [[self view] addSubview:mActionSegment];
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
            break;
        case 1: // walk
        {
            for (Skeleton *sSkeleton in [mScene skeletons])
            {
                [sSkeleton actionAnimation:@"walk"];
            }
        }
            break;
        case 2: // jump
        {
            for (Skeleton *sSkeleton in [mScene skeletons])
            {
                [sSkeleton actionAnimation:@"jump"];
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
