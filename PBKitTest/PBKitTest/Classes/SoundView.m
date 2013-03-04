/*
 *  SoundView.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 1. 29..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "SoundView.h"
#import <PBKit.h>


@implementation SoundView


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {

    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)drawRect:(CGRect)aRect
{
    CGRect           sBounds  = [self bounds];
    CGContextRef     sContext = UIGraphicsGetCurrentContext();
    CGMutablePathRef sPath    = CGPathCreateMutable();
    CGFloat          sRadius  = 130;

    CGPathMoveToPoint(sPath, NULL, sBounds.size.width / 2 + sRadius, sBounds.size.height / 2);
    for (NSInteger i = 0; i < 360; i++)
    {
        CGFloat sAngle = PBDegreesToRadians(i);
        CGPoint sPoint = CGPointMake(cosf(sAngle) * sRadius + sBounds.size.width / 2, sinf(sAngle) * sRadius + sBounds.size.height / 2);
        CGPathAddLineToPoint(sPath, NULL, sPoint.x, sPoint.y);
    }
    CGPathAddLineToPoint(sPath, NULL, sBounds.size.width / 2 + sRadius, sBounds.size.height / 2);

    CGContextSetStrokeColorWithColor(sContext, [[UIColor whiteColor] CGColor]);
    CGContextSetLineWidth(sContext, 2);
    
    CGContextAddPath(sContext, sPath);
    CGContextDrawPath(sContext, kCGPathStroke);
    
    CGPathRelease(sPath);
}


@end
