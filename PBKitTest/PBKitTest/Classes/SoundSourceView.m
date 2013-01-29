/*
 *  SoundSourceView.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 1. 29..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "SoundSourceView.h"
#import <PBKit.h>


@implementation SoundSourceView
{
    PBSoundSource *mSource;
}


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        mSource = [[PBSoundSource alloc] init];
        
        [mSource setSound:[PBSound soundNamed:@"animals012.m4a"]];
        [mSource setLooping:YES];
        [mSource setDistance:1];
        [mSource play];
    }
    
    return self;
}


- (void)dealloc
{
    [mSource release];
    
    [super dealloc];
}


- (void)setPosition:(CGPoint)aPosition
{
    CGPoint sPoint = CGPointMake(aPosition.x / 130, aPosition.y / 130);
    NSLog(@"sPoint = %@", NSStringFromCGPoint(sPoint));
    [mSource setPosition:sPoint];
}


@end
