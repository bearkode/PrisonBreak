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
{
    PBLayer *mParticle;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[PBColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f]];
        [self setDelegate:self];
        
        PBTexture *sLandscapeTexture  = [PBTextureManager textureWithImageName:@"space_background"];
        [sLandscapeTexture loadIfNeeded];
        PBLayer *sLayer = [[[PBLayer alloc] init] autorelease];
        [sLayer setTexture:sLandscapeTexture];
        [sLayer setPointZ:1.0f];
        [[self rootLayer] addSublayer:sLayer];        
    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    [mParticle removeFromSuperlayer];
    [mParticle release];
    
    [super dealloc];
}


#pragma mark -


- (void)fire:(CGPoint)aStartCoordinate count:(NSUInteger)aCount speed:(CGFloat)aSpeed
{
    if (mParticle)
    {
        [mParticle removeFromSuperlayer];
        [mParticle release];
    }
    
    mParticle = [[PBLayer alloc] init];
    [[self rootLayer] addSublayer:mParticle];
    
    NSInteger  sTextureIndex = arc4random() % 3;
    NSArray   *sImageNames   = [NSArray arrayWithObjects:@"CN_perpectflare_red.png", @"CN_perpectflare_green.png", @"CN_perpectflare_blue.png", nil];
    PBTexture *sTexture      = [[[PBTexture alloc] initWithImageName:[sImageNames objectAtIndex:sTextureIndex]] autorelease];
    [sTexture loadIfNeeded];
    
    BasicParticle *sParticle = [[[BasicParticle alloc] initWithTexture:sTexture] autorelease];
    [sParticle setParticleCount:aCount];
    [sParticle setSpeed:aSpeed];
    [sParticle fire:aStartCoordinate];

    [mParticle setMeshRenderOption:kPBMeshRenderOptionUsingCallback];
    [[mParticle mesh] setMeshRenderCallback:^{
        [sParticle draw];
    }];
}


#pragma mark -


- (void)pbCanvasWillUpdate:(PBCanvas *)aView
{
    [[ProfilingOverlay sharedManager] displayFPS:[aView fps] timeInterval:[aView timeInterval]];
}


@end
