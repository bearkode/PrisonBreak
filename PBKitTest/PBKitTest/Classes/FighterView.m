/*
 *  FighterView.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 1. 29..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "FighterView.h"
#import <PBKit.h>


@implementation FighterView
{
    id mDelegate;
}


@synthesize delegate = mDelegate;


#pragma mark -


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)touchesBegan:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    UITouch *sTouch  = [aTouches anyObject];
    CGPoint  sPoint  = [sTouch locationInView:self];
    CGRect   sBounds = [self bounds];
    
    if (sPoint.x < sBounds.size.width / 2)
    {
        [mDelegate fighterControlDidLeftYaw:self];
    }
    else
    {
        [mDelegate fighterControlDidRightYaw:self];
    }
}


- (void)touchesMoved:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    UITouch *sTouch  = [aTouches anyObject];
    CGPoint  sPoint  = [sTouch locationInView:self];
    CGRect   sBounds = [self bounds];
    
    if (sPoint.x < sBounds.size.width / 2)
    {
        [mDelegate fighterControlDidLeftYaw:self];
    }
    else
    {
        [mDelegate fighterControlDidRightYaw:self];
    }
}


- (void)touchesCancelled:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    [mDelegate fighterControlDidBalanced:self];
}


- (void)touchesEnded:(NSSet *)aTouches withEvent:(UIEvent *)aEvent
{
    [mDelegate fighterControlDidBalanced:self];
}


@end
