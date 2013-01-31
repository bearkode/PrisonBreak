/*
 *  PBSoundListener.m
 *  PBKit
 *
 *  Created by bearkode on 13. 1. 30..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBSoundListener.h"
#import <OpenAL/al.h>
#import <OpenAL/alc.h>


static CGPoint gPosition    = { 0.0, 0.0 };
static CGFloat gOrientation = 0.0;


@implementation PBSoundListener


+ (CGPoint)position
{
	return gPosition;
}


+ (void)setPosition:(CGPoint)aPosition
{
	ALfloat sPosition[3];
    
    gPosition = aPosition;
    
    sPosition[0] = gPosition.x;
    sPosition[1] = 0;
    sPosition[2] = gPosition.y;
    
	alListenerfv(AL_POSITION, sPosition);
}


+ (CGFloat)orientation
{
	return gOrientation;
}


+ (void)setOrientation:(CGFloat)aRadians
{
	ALfloat sOrientation[6];
    
    gOrientation = aRadians;
    
    sOrientation[0] = cos(aRadians + M_PI_2);
    sOrientation[1] = sin(aRadians + M_PI_2);
    sOrientation[2] = -1.0;
    sOrientation[3] = 0.0;
    sOrientation[4] = 1.0;
    sOrientation[5] = 0.0;
    
	alListenerfv(AL_ORIENTATION, sOrientation);
}


@end
