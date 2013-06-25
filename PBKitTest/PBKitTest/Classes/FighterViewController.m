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
#import "SoundKeys.h"


@implementation FighterViewController
{
    FighterView   *mFighterView;
    Fighter       *mFighter;
    
    CGFloat        mAngle;
    NSTimer       *mLeftTurnTimer;
    NSTimer       *mRightTurnTimer;
    
    PBSoundSource *mSoundSource;
}


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];

    if (self)
    {
        mSoundSource = [[PBSoundManager sharedManager] retainSoundSource];
        
        [mSoundSource setSound:[[PBSoundManager sharedManager] soundForKey:kSoundVulcan]];
        [mSoundSource setPosition:CGPointMake(0, 20)];
        [mSoundSource setLooping:YES];
        [mSoundSource play];
    }
    
    return self;
}


- (void)dealloc
{
    [mFighter release];
    [[PBSoundManager sharedManager] releaseSoundSource:mSoundSource];
    
    [PBTextureManager vacate];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect sBounds = [[self view] bounds];
    
    mFighterView = [[[FighterView alloc] initWithFrame:CGRectMake(0, 0, sBounds.size.width, 300)] autorelease];
    [mFighterView setDelegate:self];
    PBScene *sScene = [[[PBScene alloc] initWithDelegate:self] autorelease];
    [mFighterView presentScene:sScene];

    [[self view] addSubview:mFighterView];

    if (!mFighter)
    {
        mFighter = [[Fighter alloc] init];
    }
    
    [sScene setSubNodes:[NSArray arrayWithObjects:mFighter, nil]];
    
    
    UIButton *sLeftRotateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sLeftRotateButton setTitle:@"Left Turn" forState:UIControlStateNormal];
    [sLeftRotateButton setFrame:CGRectMake(10, 320, 140, 50)];
    [sLeftRotateButton addTarget:self action:@selector(leftTouchDown) forControlEvents:UIControlEventTouchDown];
    [sLeftRotateButton addTarget:self action:@selector(leftTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:sLeftRotateButton];
    
    UIButton *sRightRotateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sRightRotateButton setTitle:@"Right Turn" forState:UIControlStateNormal];
    [sRightRotateButton setFrame:CGRectMake(170, 320, 140, 50)];
    [sRightRotateButton addTarget:self action:@selector(rightTouchDown) forControlEvents:UIControlEventTouchDown];
    [sRightRotateButton addTarget:self action:@selector(rightTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:sRightRotateButton];
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


#pragma mark -


- (void)fighterControlDidLeftYaw:(FighterView *)aView
{
    [mFighter yawLeft];
}


- (void)fighterControlDidRightYaw:(FighterView *)aView
{
    [mFighter yawRight];
}


- (void)fighterControlDidBalanced:(FighterView *)aView
{
    [mFighter balance];
}


#pragma mark -


- (void)leftTurn
{
    [[mFighter transform] setAngle:PBVertex3Make(0, 0, --mAngle)];
    [mFighter yawLeft];
    
    [PBSoundListener setOrientation:PBDegreesToRadians(mAngle)];
}


- (void)rightTurn
{
    [[mFighter transform] setAngle:PBVertex3Make(0, 0, ++mAngle)];
    [mFighter yawRight];
    
    [PBSoundListener setOrientation:PBDegreesToRadians(mAngle)];    
}


- (void)leftTouchDown
{
    mLeftTurnTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)0.01 target:self selector:@selector(leftTurn) userInfo:nil repeats:TRUE];
}


- (void)leftTouchUp
{
    [mLeftTurnTimer invalidate];
    [mFighter balance];
}


- (void)rightTouchDown
{
    mRightTurnTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)0.01 target:self selector:@selector(rightTurn) userInfo:nil repeats:TRUE];
}

- (void)rightTouchUp
{
    [mRightTurnTimer invalidate];
    [mFighter balance];    
}


@end
