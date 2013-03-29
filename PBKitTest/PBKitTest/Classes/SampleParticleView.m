/*
 *  SampleParticleView.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SampleParticleView.h"
#import "ProfilingOverlay.h"
#import "BasicParticle.h"


@implementation SampleParticleView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
        [self setDelegate:self];
        mParticles = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    [mParticles release];
    
    [super dealloc];
}


#pragma mark -


- (void)clearParticles
{
    NSArray *sParticles = [mParticles copy];
    for (NSInteger i = 0; i < [sParticles count]; i++)
    {
        BasicParticle *sParticle = [sParticles objectAtIndex:i];
        [sParticle finished];
    }
    [sParticles release];
}


- (void)fire:(CGPoint)aStartCoordinate count:(NSUInteger)aCount speed:(CGFloat)aSpeed
{
    NSInteger  sTextureIndex = arc4random() % 3;
    NSArray   *sImageNames   = [NSArray arrayWithObjects:@"CN_perpectflare_red.png", @"CN_perpectflare_green.png", @"CN_perpectflare_blue.png", nil];
    PBTexture *sTexture      = [[[PBTexture alloc] initWithImageName:[sImageNames objectAtIndex:sTextureIndex]] autorelease];

    [sTexture loadIfNeeded];
    
    BasicParticle *sParticle = [[[BasicParticle alloc] initWithTexture:sTexture] autorelease];
    [sParticle setParticleCount:aCount];
    [sParticle setSpeed:aSpeed];
    [sParticle setPlaybackBlock:^() {
        [mParticles removeObject:sParticle];
    }];
    [mParticles addObject:sParticle];
    [sParticle fire:aStartCoordinate];
}


#pragma mark -


- (void)pbCanvasWillUpdate:(PBCanvas *)aView
{
    [[ProfilingOverlay sharedManager] displayFPS:[aView fps] timeInterval:[aView timeInterval]];
    
    for (NSInteger i = 0; i < [mParticles count]; i++)
    {
        BasicParticle *sParticle = [mParticles objectAtIndex:i];
        [sParticle draw];
    }
}


@end
