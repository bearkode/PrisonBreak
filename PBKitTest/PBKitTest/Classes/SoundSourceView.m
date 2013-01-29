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
        
//        PBSound *sSound = [[[PBSound alloc] initWithName:@"bomb_explosion.caf" isLooping:YES] autorelease];
        PBSound *sSound = [[[PBSound alloc] initWithName:@"animals012.m4a" isLooping:YES] autorelease];
        
//        [mSource setSound:[PBSound soundNamed:@"bomb_explosion.caf"]];
//        [mSource play];
    }
    
    return self;
}


- (void)dealloc
{
    [mSource release];
    
    [super dealloc];
}


@end
