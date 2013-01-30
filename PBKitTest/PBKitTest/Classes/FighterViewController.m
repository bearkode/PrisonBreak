/*
 *  FighterViewController.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 1. 29..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "FighterViewController.h"
#import "FighterView.h"
#import <PBKit.h>


@implementation FighterViewController
{
    FighterView *mFighterView;
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
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect sBounds = [[self view] bounds];
    
    mFighterView = [[[FighterView alloc] initWithFrame:CGRectMake(0, 0, sBounds.size.width, 260)] autorelease];
    [[self view] addSubview:mFighterView];
    
    PBTexture    *sTexture    = [[[PBTexture alloc] initWithImageName:@"3fc"] autorelease];
    PBRenderable *sRenderable = [[PBRenderable alloc] init];
    
    [sTexture load];
    [sRenderable setTexture:sTexture];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    mFighterView = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    [mFighterView  stopDisplayLoop];
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
    
    [mFighterView stopDisplayLoop];
}


@end
