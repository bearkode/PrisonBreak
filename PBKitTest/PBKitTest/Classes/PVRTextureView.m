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
    PBRenderable *mRenderable;
    PBTexture    *mTexture;
    CGFloat       mScale;
    CGFloat       mAngle;
}


#pragma mark -


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
        
        NSString *sPath = [[NSBundle mainBundle] pathForResource:@"brown" ofType:@"pvr"];
        mTexture = [[PBTexture alloc] initWithPath:sPath];
        [mTexture load];
        
        mRenderable = [[PBRenderable alloc] initWithTexture:mTexture];
        [mRenderable setProgram:[[PBProgramManager sharedManager] bundleProgram]];
        [mRenderable setTransform:[[[PBTransform alloc] init] autorelease]];

        PBBlendMode sMode = { GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA };
        [mRenderable setBlendMode:sMode];
        
        [[self renderable] setSubrenderables:[NSArray arrayWithObject:mRenderable]];
    }
    
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    
    [mRenderable release];
    [mTexture release];

    [super dealloc];
}


#pragma mark -


- (void)pbCanvasUpdate:(PBCanvas *)aView
{
    [[ProfilingOverlay sharedManager] displayFPS:[aView fps] timeInterval:[aView timeInterval]];
    
    [[mRenderable transform] setScale:[self scale]];
    [[mRenderable transform] setAngle:PBVertex3Make(0, 0, [self angle])];
    [[mRenderable transform] setAlpha:[self alpha]];
    [[mRenderable transform] setBlurEffect:[self blur]];
    [[mRenderable transform] setGrayScaleEffect:[self grayScale]];
    [[mRenderable transform] setLuminanceEffect:[self luminance]];
    [[mRenderable transform] setSepiaEffect:[self sepia]];
    [mRenderable  setPosition:CGPointMake(0, 0)];
}


@end
