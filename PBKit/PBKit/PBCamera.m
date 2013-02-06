/*
 *  PBCamera.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 6..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBCamera.h"


@implementation PBCamera
{
    CGPoint mPosition;
    CGFloat mZoomScale;
}


@synthesize zoomScale = mZoomScale;


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mPosition  = CGPointMake(0, 0);
        mZoomScale = 1.0;
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (CGPoint)position
{
    return mPosition;
}


- (void)setPosition:(CGPoint)aPosition
{
    if (!CGPointEqualToPoint(aPosition, mPosition))
    {
        [self willChangeValueForKey:@"position"];
        
        mPosition = aPosition;
        
        [self didChangeValueForKey:@"position"];
    }
}


@end
