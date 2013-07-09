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


- (IBAction)radial:(id)aSender
{
    [mParticleView radial];
}


- (IBAction)flame:(id)aSender
{
    [mParticleView flame];
}


@end
