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
#import "SoundKeys.h"


@implementation SoundSourceView
{
    PBSoundSource *mSource;
}


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        mSource = [[PBSoundManager sharedManager] retainSoundSource];
        
        [mSource setSound:[[PBSoundManager sharedManager] soundForKey:kSoundAnimals012]];
        [mSource setLooping:YES];
        [mSource setDistance:1];
        [mSource play];
    }
    
    return self;
}


- (void)dealloc
{
    [[PBSoundManager sharedManager] releaseSoundSource:mSource];
    
    [super dealloc];
}


- (void)setPosition:(CGPoint)aPosition
{
    CGPoint sPoint = CGPointMake(aPosition.x / 130, aPosition.y / 130);

    [mSource setPosition:sPoint];
}


@end
