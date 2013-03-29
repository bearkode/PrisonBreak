/*
 *  PVRTextureView.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 1. 24..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PVRTextureView.h"
#import "ProfilingOverlay.h"


@implementation PVRTextureView
{
    PBSprite  *mLayer;
    PBTexture *mTexture;
    CGFloat    mScale;
    CGFloat    mAngle;
}


#pragma mark -


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        [self setDelegate:self];
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
        
        NSString *sPath = [[NSBundle mainBundle] pathForResource:@"brown" ofType:@"pvr"];
        mTexture = [[PBTexture alloc] initWithPath:sPath];
        [mTexture loadIfNeeded];
        
        mLayer = [[PBSprite alloc] initWithTexture:mTexture];
        PBBlendMode sMode = { GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA };
        [mLayer setBlendMode:sMode];
        
        [[self rootLayer] setSublayers:[NSArray arrayWithObject:mLayer]];
    }
    
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    
    [mLayer release];
    [mTexture release];

    [super dealloc];
}


#pragma mark -


- (void)pbCanvasWillUpdate:(PBCanvas *)aView
{
    [[ProfilingOverlay sharedManager] displayFPS:[aView fps] timeInterval:[aView timeInterval]];
    
    [[mLayer transform] setScale:[self scale]];
    [[mLayer transform] setAngle:PBVertex3Make(0, 0, [self angle])];
    [[mLayer transform] setAlpha:[self alpha]];
    [mLayer  setPoint:CGPointMake(0, 0)];
    
    [[mLayer transform] setGrayscale:mGrayScale];
    [[mLayer transform] setSepia:mSepia];
    [[mLayer transform] setBlur:mBlur];
    [[mLayer transform] setLuminance:mLuminance];
}


@end
