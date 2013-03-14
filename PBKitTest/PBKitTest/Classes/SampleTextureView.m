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

        [self setBackgroundColor:[PBColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
        
        mAirship = [[PBSprite alloc] initWithImageName:@"airship"];
        mPoket1  = [[PBSprite alloc] initWithImageName:@"poket0118"];
        mPoket2  = [[PBSprite alloc] initWithImageName:@"poket0119"];        
//        mCoin    = [[PBSprite alloc] initWithImageName:@"coin"];

        [mAirship setName:@"airship"];
        [mPoket1 setName:@"poket0118"];
        [mPoket2 setName:@"poket0119"];
//        [mCoin setName:@"coin"];

        [mAirship setPoint:CGPointMake(-40, 0)];
        [mPoket1 setPoint:CGPointMake(-80, 0)];
        [mPoket2 setPoint:CGPointMake(80, 0)];
//        [mCoin setPosition:CGPointMake(-70, -30)];

        
        [[mAirship mesh] setBoundary:YES];
        [[mPoket1 mesh] setBoundary:YES];
        [[mPoket2 mesh] setBoundary:YES];
        
        mScreen = [[PBLayer alloc] init];
        [mScreen setName:@"screen"];
        [mScreen setPoint:CGPointMake(-20, 0)];
        
        
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

    [[mAirship transform] setGrayscale:mGrayScale];
    [[mPoket1 transform] setGrayscale:mGrayScale];
    [[mPoket2 transform] setGrayscale:mGrayScale];
    
    [[mAirship transform] setSepia:mSepia];
    [[mPoket1 transform] setSepia:mSepia];
    [[mPoket2 transform] setSepia:mSepia];
    
    [[mAirship transform] setBlur:mBlur];
    [[mPoket1 transform] setBlur:mBlur];
    [[mPoket2 transform] setBlur:mBlur];
    
    [[mAirship transform] setLuminance:mLuminance];
    [[mPoket1 transform] setLuminance:mLuminance];
    [[mPoket2 transform] setLuminance:mLuminance];
}


@end
