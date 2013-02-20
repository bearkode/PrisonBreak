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


@implementation SampleTextureView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self registGestureEvent];

        [self setBackgroundColor:[PBColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
        
        mAirship = [[PBSprite alloc] initWithImageName:@"airship"];
        mPoket1  = [[PBSprite alloc] initWithImageName:@"poket0118"];
        mPoket2  = [[PBSprite alloc] initWithImageName:@"poket0119"];        
        mCoin    = [[PBSprite alloc] initWithImageName:@"coin"];
        
        [mAirship setName:@"airship"];
        [mPoket1 setName:@"poket0118"];
        [mPoket2 setName:@"poket0119"];
        [mCoin setName:@"coin"];
        
        [mAirship setPosition:CGPointMake(40, 0)];
        [mPoket1 setPosition:CGPointMake(-80, 0)];
        [mPoket2 setPosition:CGPointMake(80, 0)];
        [mCoin setPosition:CGPointMake(-70, -30)];
        
        [mAirship setSelectable:YES];
        [mPoket1 setSelectable:YES];
        [mPoket2 setSelectable:YES];
        [mCoin setSelectable:YES];

        mScreen = [[PBRenderable alloc] init];
        [mScreen setProgram:[[PBProgramManager sharedManager] bundleProgram]];
        [mScreen setName:@"screen"];
        [mScreen setPosition:CGPointMake(-20, 0)];
        
        
        [mAirship setSubrenderables:[NSArray arrayWithObjects:mPoket1, mPoket2, nil]];
        [mScreen setSubrenderables:[NSArray arrayWithObjects:mAirship, nil]];
        
        [[self renderable] setSubrenderables:[NSArray arrayWithObjects:mScreen, nil]];

    }
    return self;
}


- (void)dealloc
{
    [mAirship release];
    [mPoket1 release];
    [mPoket2 release];
    [mCoin release];
    
    [mScreen release];
    
    [super dealloc];
}


#pragma mark -


- (void)pbCanvasUpdate:(PBCanvas *)aView timeInterval:(CFTimeInterval)aTimeInterval displayLink:(CADisplayLink *)aDisplayLink
{
    PBTransform *sAirshipTransform = [[[PBTransform alloc] init] autorelease];
    [sAirshipTransform setScale:[self scale]];
    [sAirshipTransform setAngle:PBVertex3Make(0, 0, [self angle])];
    [sAirshipTransform setAlpha:[self alpha]];
    [sAirshipTransform setBlurEffect:[self blur]];
    [sAirshipTransform setGrayScaleEffect:[self grayScale]];
    [sAirshipTransform setLuminanceEffect:[self luminance]];
    [sAirshipTransform setSepiaEffect:[self sepia]];
    [mAirship setTransform:sAirshipTransform];
    
    PBTransform *sCoinTransform = [[[PBTransform alloc] init] autorelease];
    [sCoinTransform setScale:[self scale]];
    [sCoinTransform setAngle:PBVertex3Make(0, 0, [self angle])];
    [sCoinTransform setAlpha:[self alpha]];
    [sCoinTransform setBlurEffect:[self blur]];
    [sCoinTransform setGrayScaleEffect:[self grayScale]];
    [sCoinTransform setLuminanceEffect:[self luminance]];
    [sCoinTransform setSepiaEffect:[self sepia]];
    [mCoin setTransform:sCoinTransform];
}


- (void)pbCanvas:(PBCanvas *)aView didTapPoint:(CGPoint)aPoint
{
    // select test
    [self beginSelectionMode];
    PBRenderable *sSelectedRenderable = [self selectedRenderableAtPoint:aPoint];
    if ([sSelectedRenderable name])
    {
         NSLog(@"selected = %@", [sSelectedRenderable name]);   
    }
    [self endSelectionMode];
}


@end
