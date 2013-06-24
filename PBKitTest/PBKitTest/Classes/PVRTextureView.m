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
    PBSprite  *mNode;
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
        
        mNode = [[PBSprite alloc] initWithTexture:mTexture];
        [[self scene] setSubNodes:[NSArray arrayWithObject:mNode]];
    }
    
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    
    [mNode release];
    [mTexture release];

    [super dealloc];
}


#pragma mark -


- (void)pbCanvasWillUpdate:(PBCanvas *)aView
{
    [[ProfilingOverlay sharedManager] displayFPS:[aView fps] timeInterval:[aView timeInterval]];
    
    [[mNode transform] setScale:[self scale]];
    [[mNode transform] setAngle:PBVertex3Make(0, 0, [self angle])];
    [[mNode transform] setAlpha:[self alpha]];
    [mNode  setPoint:CGPointMake(0, 0)];
    
    [[mNode transform] setGrayscale:mGrayScale];
    [[mNode transform] setSepia:mSepia];
    [[mNode transform] setBlur:mBlur];
    [[mNode transform] setLuminance:mLuminance];
}


@end
