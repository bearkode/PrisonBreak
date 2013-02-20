/*
 *  TextureView.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 2. 19..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "TextureView.h"


@implementation TextureView


@synthesize scale     = mScale;
@synthesize angle     = mAngle;
@synthesize alpha     = mAlpha;
@synthesize blur      = mBlur;
@synthesize luminance = mLuminance;
@synthesize grayScale = mGrayScale;
@synthesize sepia     = mSepia;


#pragma mark -


- (void)pbCanvasUpdate:(PBCanvas *)aView timeInterval:(CFTimeInterval)aTimeInterval displayLink:(CADisplayLink *)aDisplayLink
{    
}


@end
