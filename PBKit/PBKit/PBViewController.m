/*
 *  PBViewController.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 22..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBViewController.h"


@implementation PBViewController
{
    PBCanvas *mCanvas;
}

@synthesize canvas = mCanvas;


#pragma mark -


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


#pragma  mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect sBounds = [[self view] bounds];
    
    mCanvas = [[[PBCanvas alloc] initWithFrame:sBounds] autorelease];
    [mCanvas setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [[self view] addSubview:mCanvas];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    mCanvas = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    mCanvas = nil;    
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];
    
    [mCanvas startDisplayLoop];
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
    
    [mCanvas stopDisplayLoop];
}


@end
