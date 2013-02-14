/*
 *  SoundViewController.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 1. 29..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "SoundViewController.h"
#import <PBKit.h>
#import "SoundView.h"
#import "SoundSourceView.h"


@implementation SoundViewController
{
    NSTimer         *mTimer;
    NSInteger        mTick;
    
    SoundSourceView *mSourceView;
}


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


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect sBounds = [[self view] bounds];

    SoundView *sView = [[[SoundView alloc] initWithFrame:sBounds] autorelease];
    [[self view] addSubview:sView];
    
    mSourceView = [[[SoundSourceView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)] autorelease];
    [mSourceView setImage:[UIImage imageNamed:@"poket0015"]];
    [sView addSubview:mSourceView];
    
    [PBSoundListener setOrientation:0];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];

    mTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeTick:) userInfo:nil repeats:YES];
    mTick  = 0;
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];

    [mTimer invalidate];
}


#pragma mark -


- (void)timeTick:(id)aTimer
{
    CGRect  sBounds  = [[self view] bounds];
    CGFloat sRadius  = 130;

    if (mTick >= 360)
    {
        mTick = 0;
    }
    else
    {
        mTick += 5;
    }
    
    CGFloat sAngle = PBDegreesToRadians(mTick);
    CGPoint sPoint = CGPointMake(cosf(sAngle) * sRadius, sinf(sAngle) * sRadius);
    [mSourceView setFrame:CGRectMake(sPoint.x + sBounds.size.width / 2 - 40, sPoint.y + sBounds.size.height / 2 - 40, 80, 80)];
    [mSourceView setPosition:CGPointMake(sPoint.x, -sPoint.y)];
}


@end
