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
        
        [mAirship setPosition:CGPointMake(-70, 30)];
        [mPoket1 setPosition:CGPointMake(-40, 40)];
        [mPoket2 setPosition:CGPointMake(40, 40)];
        [mCoin setPosition:CGPointMake(70, -30)];
        
        [mAirship setSelectable:YES];
        [mPoket1 setSelectable:YES];
        [mPoket2 setSelectable:YES];
        [mCoin setSelectable:YES];


//        [[mPoket2 transform] setColor:[PBColor grayColor]];
//        [[mRenderable2 transform] setAlpha:0.3f];
    }
    return self;
}


- (void)dealloc
{
    [mAirship release];
    [mPoket1 release];
    [mPoket2 release];
    [mCoin release];
    
    [super dealloc];
}


#pragma mark -


- (void)pbCanvasUpdate:(PBCanvas *)aView timeInterval:(CFTimeInterval)aTimeInterval displayLink:(CADisplayLink *)aDisplayLink
{
    [[mAirship transform] setScale:mScale];
    [[mAirship transform] setAngle:PBVertex3Make(0, 0, mAngle)];
    [[mAirship transform] setAlpha:mAlpha];
    [[mAirship transform] setBlurEffect:mBlur];
    [[mAirship transform] setGrayScaleEffect:mGrayScale];
    [[mAirship transform] setLuminanceEffect:mLuminance];
    [[mAirship transform] setSepiaEffect:mSepia];
    
    [[mCoin transform] setScale:mScale];
    [[mCoin transform] setAngle:PBVertex3Make(0, 0, mAngle)];
    [[mCoin transform] setAlpha:mAlpha];
    [[mCoin transform] setBlurEffect:mBlur];
    [[mCoin transform] setGrayScaleEffect:mGrayScale];
    [[mCoin transform] setLuminanceEffect:mLuminance];
    [[mCoin transform] setSepiaEffect:mSepia];
   
    // subrenderable test
    [mAirship setSubrenderables:[NSArray arrayWithObjects:mPoket1, mPoket2, nil]];
    [[self renderable] setSubrenderables:[NSArray arrayWithObjects:mAirship, mCoin, nil]];
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
