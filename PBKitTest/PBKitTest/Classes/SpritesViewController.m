/*
 *  SpritesViewController.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 6. 19..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SpritesViewController.h"
#import <PBKit.h>
#import "ProfilingOverlay.h"


@implementation SpritesViewController
{
    NSMutableArray *mLayers;
}


#pragma mark -


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        mLayers = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
 
    [mLayers release];
    [[self canvas] setDelegate:nil];
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self canvas] setBackgroundColor:[PBColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f]];
    [[self canvas] setDelegate:self];
    [[self canvas] registGestureEvent];
    [[self canvas] setDisplayFrameRate:kPBDisplayFrameRateHigh];
    
}


#pragma mark -


- (void)pbCanvasWillUpdate:(PBCanvas *)aView
{
    [[ProfilingOverlay sharedManager] displayFPS:[aView fps] timeInterval:[aView timeInterval]];
    
//    for (PBLayer *sLayer in mLayers)
//    {
//        CGFloat sAngle = [[sLayer transform] angle].z;
//        [[sLayer transform] setAngle:PBVertex3Make(0, 0, ++sAngle)];
//    }
}


- (void)pbCanvas:(PBCanvas *)aCanvas didTapPoint:(CGPoint)aPoint
{
    CGPoint sPoint = [aCanvas canvasPointFromViewPoint:aPoint];
    

    for (int i = 0; i < 10; i++)
    {
        PBSprite *sSprite = [[[PBSprite alloc] initWithImageName:@"Spaceship_sm"] autorelease];
        sPoint.x += i;
        [sSprite setPoint:sPoint];
        
        [[[self canvas] rootLayer] addSublayer:sSprite];
        [mLayers addObject:sSprite];
    }
    
    [[self navigationItem] setTitle:[NSString stringWithFormat:@"Count : %d", [mLayers count]]];
}


@end
