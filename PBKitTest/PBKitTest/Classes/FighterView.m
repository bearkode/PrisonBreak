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


- (void)rendering
{
    [mSuperRenderable setScale:1.0];
    
    PBVertice4 sVertices;
    CGFloat sVerticeX1 = 0.5;
    CGFloat sVerticeX2 = sVerticeX1 * -1;
    CGFloat sVerticeY1 = 0.5;
    CGFloat sVerticeY2 = sVerticeY1 * -1;
    
    sVertices = PBVertice4Make(sVerticeX1, sVerticeY1, sVerticeX2, sVerticeY2);
    [mSuperRenderable setVertices:sVertices];
}


@end
