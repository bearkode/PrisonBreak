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


@implementation PathTestViewController
{
    PBView   *mView;

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

        mPath = [NSJSONSerialization JSONObjectWithData:sData options:0 error:nil];
    }
    
    return self;
}


- (void)dealloc
{
    [mFighter release];
    [mPath release];
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mView = [[[PBView alloc] initWithFrame:[[self view] bounds]] autorelease];

    [mView setDisplayDelegate:self];
    [mView setBackgroundColor:[PBColor blackColor]];
    
    if (!mFighter)
    {
        mFighter = [[Fighter alloc] init];
        mIndex   = 1;
    }
    
    [[mView renderable] setSubrenderables:[NSArray arrayWithObject:mFighter]];
    
    [[self view] addSubview:mView];
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


- (void)pbViewUpdate:(PBView *)aView timeInterval:(CFTimeInterval)aTimeInterval displayLink:(CADisplayLink *)aDisplayLink
{
    if (mIndex < [mPath count])
    {
//        NSDictionary *sVecDict  = [mPath objectAtIndex:mIndex];
//        CGFloat       sX        = [[sVecDict objectForKey:@"x"] floatValue];
//        CGFloat       sY        = [[sVecDict objectForKey:@"y"] floatValue];
//        CGPoint       sPosition = [mFighter position];
//        
//        [mFighter setPosition:sPosition];
    }
    else
    {
        mIndex = 1;
    }
}


@end
