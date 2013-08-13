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


@implementation SampleParticleViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}


- (void)dealloc
{
    [PBTextureManager vacate];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];

    mParticleView = [[[SampleParticleView alloc] initWithFrame:CGRectMake(0, 0, 320, 385)] autorelease];
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


- (IBAction)particleSelected:(UISegmentedControl *)aSender
{
    [mParticleView setType:[aSender selectedSegmentIndex]];
    switch ([aSender selectedSegmentIndex])
    {
        case kSelectParticleNone:
            break;
        case kSelectParticlRadial:
            [mParticleView radial];
            break;
        case kSelectParticleFlame:
            [mParticleView flame];
            break;
        case kSelectParticleRain:
            [mParticleView rain];
            break;
        case kSelectParticleSpurt:
            [mParticleView spurt];
            break;
        default:
            break;
    }
}


@end
