/*
 *  SampleTextureView.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 21..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "SampleTextureView.h"
#import <PBKit.h>
#import "ProfilingOverlay.h"


@implementation SampleTextureView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setDelegate:self];
        [self registGestureEvent];

        [self setBackgroundColor:[PBColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
        
        mAirship = [[PBSprite alloc] initWithImageName:@"airship"];
        mPoket1  = [[PBSprite alloc] initWithImageName:@"poket0118"];
        mPoket2  = [[PBSprite alloc] initWithImageName:@"poket0119"];        
//        mCoin    = [[PBSprite alloc] initWithImageName:@"coin"];

        [mAirship setName:@"airship"];
        [mPoket1 setName:@"poket0118"];
        [mPoket2 setName:@"poket0119"];
//        [mCoin setName:@"coin"];

        [mAirship setPosition:CGPointMake(-40, 0)];
        [mPoket1 setPosition:CGPointMake(-80, 0)];
        [mPoket2 setPosition:CGPointMake(80, 0)];
//        [mCoin setPosition:CGPointMake(-70, -30)];

        [mAirship setSelectable:YES];
        [mPoket1 setSelectable:YES];
        [mPoket2 setSelectable:YES];
//        [mCoin setSelectable:YES];

        mScreen = [[PBLayer alloc] init];
        [mScreen setName:@"screen"];
        [mScreen setPosition:CGPointMake(-20, 0)];
        
        
        [mAirship setSublayers:[NSArray arrayWithObjects:mPoket1, mPoket2, nil]];
        [mScreen setSublayers:[NSArray arrayWithObjects:mAirship, nil]];
        
        [[self rootLayer] setSublayers:[NSArray arrayWithObjects:mAirship, nil]];

    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    
    [mAirship release];
    [mPoket1 release];
    [mPoket2 release];
    [mCoin release];
    
    [mScreen release];
    
    [super dealloc];
}


#pragma mark -


- (void)pbCanvasUpdate:(PBCanvas *)aView
{
    [[ProfilingOverlay sharedManager] displayFPS:[aView fps] timeInterval:[aView timeInterval]];
    
    [[mAirship transform] setScale:[self scale]];
    [[mAirship transform] setAngle:PBVertex3Make(0, 0, [self angle])];
    [[mAirship transform] setAlpha:[self alpha]];
    
    [[mPoket2 transform] setScale:[self scale]];
    [[mPoket2 transform] setAngle:PBVertex3Make(0, 0, [self angle] * 3)];
    [[mPoket2 transform] setAlpha:[self alpha]];
    
    [[mCoin transform] setScale:[self scale]];
    [[mCoin transform] setAngle:PBVertex3Make(0, 0, [self angle])];
    [[mCoin transform] setAlpha:[self alpha]];
}


- (void)pbCanvas:(PBCanvas *)aView didTapPoint:(CGPoint)aPoint
{
    // select test
    [self beginSelectionMode];
    PBLayer *sSelectedLayer = [self selectedLayerAtPoint:aPoint];
    if ([sSelectedLayer name])
    {
         NSLog(@"selected = %@", [sSelectedLayer name]);   
    }
    [self endSelectionMode];
}


@end
