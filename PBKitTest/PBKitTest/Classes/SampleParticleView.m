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
    PBScene *mScene;
    PBNode  *mParticle;
}


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self)
    {
        mScene = [[PBScene alloc] initWithDelegate:self];
        [self setBackgroundColor:[PBColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f]];
        [self presentScene:mScene];
        
        PBSpriteNode *sSpriteNode = [[[PBSpriteNode alloc] initWithImageNamed:@"space_background"] autorelease];
        [sSpriteNode setZPoint:1.0f];
        [mScene addSubNode:sSpriteNode];
    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    [mScene release];
    [mParticle drainMeshRenderCallback];
    [mParticle removeFromSuperNode];
    [mParticle release];
    
    [super dealloc];
}


#pragma mark -


- (void)fire:(CGPoint)aStartCoordinate count:(NSUInteger)aCount speed:(CGFloat)aSpeed
{
    if (mParticle)
    {
        [mParticle drainMeshRenderCallback];
        [mParticle removeFromSuperNode];
        [mParticle release];
    }
    
    mParticle = [[PBNode alloc] init];
    [mScene addSubNode:mParticle];
    
    NSInteger  sTextureIndex = arc4random() % 3;
    NSArray   *sImageNames   = [NSArray arrayWithObjects:@"CN_perpectflare_red.png", @"CN_perpectflare_green.png", @"CN_perpectflare_blue.png", nil];
    PBTexture *sTexture      = [[[PBTexture alloc] initWithImageName:[sImageNames objectAtIndex:sTextureIndex]] autorelease];
    [sTexture loadIfNeeded];
    
    BasicParticle *sParticle = [[[BasicParticle alloc] initWithTexture:sTexture] autorelease];
    [sParticle setParticleCount:aCount];
    [sParticle setSpeed:aSpeed];
    [sParticle fire:aStartCoordinate];

    [mParticle setMeshRenderOption:kPBMeshRenderOptionUsingCallback];
    [mParticle setMeshRenderCallback:^{
        [sParticle draw];        
    }];
}


#pragma mark -


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
    [[ProfilingOverlay sharedManager] displayFPS:[self fps] timeInterval:[self timeInterval]];
}


@end
