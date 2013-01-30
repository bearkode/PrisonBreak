/*
 *  FighterViewController.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 1. 29..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "FighterViewController.h"
#import <PBKit.h>
#import "FighterView.h"
#import "Fighter.h"


@implementation FighterViewController
{
    FighterView *mFighterView;
    Fighter     *mFighter;
}


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];

    if (self)
    {

    }
    
    return self;
}


- (void)dealloc
{
    [mFighter release];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect sBounds = [[self view] bounds];
    
    mFighterView = [[[FighterView alloc] initWithFrame:CGRectMake(0, 0, sBounds.size.width, 300)] autorelease];
    [[self view] addSubview:mFighterView];

    if (!mFighter)
    {
        mFighter = [[Fighter alloc] init];
    }
    
    [mFighterView setSuperRenderable:mFighter];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    mFighterView = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    [mFighterView  startDisplayLoop];
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
    
    [mFighterView stopDisplayLoop];
}


@end
