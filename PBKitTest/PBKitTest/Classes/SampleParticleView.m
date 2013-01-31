/*
 *  SampleParticleView.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SampleParticleView.h"


@implementation SampleParticleView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
        mParticles = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)dealloc
{
    [mParticles release];
    
    [super dealloc];
}


#pragma mark -


- (void)fire:(CGPoint)aStartCoordinate count:(NSUInteger)aCount speed:(CGFloat)aSpeed
{
    NSInteger  sTextureIndex = arc4random() % 3;
    NSArray   *sImageNames   = [NSArray arrayWithObjects:@"CN_perpectflare_red.png", @"CN_perpectflare_green.png", @"CN_perpectflare_blue.png", nil];
    PBTexture *sTexture      = [[[PBTexture alloc] initWithImageName:[sImageNames objectAtIndex:sTextureIndex]] autorelease];

    [sTexture load];
    
    PBBasicParticle *sParticle = [[[PBBasicParticle alloc] initWithTexture:sTexture] autorelease];
    [sParticle setParticleCount:aCount];
    [sParticle setSpeed:aSpeed];
    [sParticle setPlaybackBlock:^() {
        [mParticles removeObject:sParticle];
    }];
    [mParticles addObject:sParticle];
    [sParticle fire:aStartCoordinate];
}


#pragma mark -


- (void)pbViewUpdate:(PBView *)aView timeInterval:(CFTimeInterval)aTimeInterval displayLink:(CADisplayLink *)aDisplayLink
{
    for (NSInteger i = 0; i < [mParticles count]; i++)
    {
        PBBasicParticle *sParticle = [mParticles objectAtIndex:i];
        [sParticle draw];
    }
}


@end
