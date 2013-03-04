/*
 *  PathTestViewController.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 1. 31..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PathTestViewController.h"
#import <PBKit.h>
#import "Fighter.h"
#import "ProfilingOverlay.h"


static CGPoint kStartPosition = { 0, -200 };


@implementation PathTestViewController
{
    PBCanvas *mView;

    Fighter  *mFighter;
    NSArray  *mPath;
    NSInteger mIndex;
}


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    
    if (self)
    {
        NSString *sPath = [[NSBundle mainBundle] pathForResource:@"path" ofType:@"json"];
        NSData   *sData = [NSData dataWithContentsOfFile:sPath];

        mPath = [[NSJSONSerialization JSONObjectWithData:sData options:0 error:nil] retain];
        
        mFighter = [[Fighter alloc] init];
        [mFighter setPosition:kStartPosition];
        [[mFighter transform] setScale:0.15];
        mIndex   = 1;
    }
    
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    
    [mFighter release];
    [mPath release];
    
    [PBMeshArrayPool vacate];
    [PBTextureManager vacate];
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mView = [[[PBCanvas alloc] initWithFrame:[[self view] bounds]] autorelease];
    [mView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [mView setDelegate:self];
    [mView setBackgroundColor:[PBColor blackColor]];
    [[self view] addSubview:mView];
    
    [[mView rootLayer] addSublayer:mFighter];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    mView = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];
    
    [mView startDisplayLoop];
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
    
    [mView stopDisplayLoop];
}


- (void)pbCanvasUpdate:(PBCanvas *)aView
{
    [[ProfilingOverlay sharedManager] displayFPS:[aView fps] timeInterval:[aView timeInterval]];
    
    if (mIndex < [mPath count])
    {
        NSDictionary *sVecDict  = [mPath objectAtIndex:mIndex];
        CGFloat       sX        = [[sVecDict objectForKey:@"x"] integerValue] / 1.5;
        CGFloat       sY        = [[sVecDict objectForKey:@"y"] integerValue] / 1.5;
        CGPoint       sPosition = [mFighter position];
        
        sPosition.x += sX;
        sPosition.y += sY;
        
        [mFighter setPosition:sPosition];

        CGFloat sAngle1 = 90 - PBRadiansToDegrees(atan2f(sY, sX));
        
        if (mIndex + 1 < [mPath count])
        {
            sVecDict = [mPath objectAtIndex:mIndex + 1];
            sX = [[sVecDict objectForKey:@"x"] integerValue] / 1.5;
            sY = [[sVecDict objectForKey:@"y"] integerValue] / 1.5;

            CGFloat sAngle = 90 - PBRadiansToDegrees(atan2f(sY, sX));
            
            [[mFighter transform] setAngle:PBVertex3Make(0, 0, sAngle)];
            
            if (sAngle1 > sAngle)
            {
                [mFighter yawLeft];
            }
            else
            {
                [mFighter yawRight];
            }
        }

        mIndex++;
    }
    else
    {
        [mFighter setPosition:kStartPosition];
        mIndex = 1;
    }
}


@end
