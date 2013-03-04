/*
 *  SampleParticleViewController.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SampleParticleViewController.h"
#import "SampleParticleView.h"


#define kDefaultParticleCount 500
#define kDefaultParticleSpeed 0.03


@implementation SampleParticleViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [mCountSlide setMinimumValue:10];
        [mCountSlide setMaximumValue:1000];
        [mCountSlide setValue:kDefaultParticleCount];
        mParticleCount = kDefaultParticleCount;
        
        [mSpeedSlide setMinimumValue:0.01];
        [mSpeedSlide setMaximumValue:0.1];
        [mSpeedSlide setValue:kDefaultParticleSpeed];
        mSpeed = kDefaultParticleSpeed;
    }
    return self;
}


- (void)dealloc
{
    [mParticleView clearParticles];
    [PBMeshArrayPool vacate];
    [PBTextureManager vacate];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect sBound = [[UIScreen mainScreen] bounds];
    
    mParticleView = [[[SampleParticleView alloc] initWithFrame:CGRectMake(0, 0, sBound.size.width, sBound.size.width)] autorelease];
    [[self view] addSubview:mParticleView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    mParticleView = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    mParticleView = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];
    
    [mParticleView startDisplayLoop];
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
    
    [mParticleView stopDisplayLoop];
}


#pragma mark -


- (IBAction)speedChanged:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    mSpeed            = [sSlider value];
    NSLog(@"%@", [NSString stringWithFormat:@"%.2f", mSpeed]);
    [mSpeedLabel setText:[NSString stringWithFormat:@"%.2f", mSpeed]];
}


- (IBAction)countChanged:(id)aSender
{
    UISlider  *sSlider = (UISlider *)aSender;
    mParticleCount     = [sSlider value];
    NSLog(@"%@", [NSString stringWithFormat:@"%d", mParticleCount]);
    [mCountLabel setText:[NSString stringWithFormat:@"%d", mParticleCount]];
}


- (IBAction)fire:(id)aSender
{
    [mParticleView fire:CGPointMake(0, 0) count:mParticleCount speed:mSpeed];
}


@end
