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
#import "RadialParticleProgram.h"


@implementation SampleParticleView
{
    PBScene               *mScene;
    PBEffectNode          *mEffectNode;
    RadialParticleProgram *mParticleProgram;
}


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self)
    {
        mScene = [[PBScene alloc] initWithDelegate:self];
        [self setBackgroundColor:[PBColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f]];
        [self presentScene:mScene];
        
        PBSpriteNode *sBackground = [[[PBSpriteNode alloc] initWithImageNamed:@"space_background"] autorelease];
        mParticleProgram = [[RadialParticleProgram alloc] init];
        mEffectNode      = [[PBEffectNode alloc] init];
        [mEffectNode setProgram:mParticleProgram];

        [mScene setSubNodes:[NSArray arrayWithObjects:sBackground, mEffectNode, nil]];
    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    [mParticleProgram release];
    [mEffectNode release];
    [mScene release];
    
    [super dealloc];
}


#pragma mark -


- (void)fire:(CGPoint)aStartCoordinate count:(NSUInteger)aCount speed:(CGFloat)aSpeed
{
    [mParticleProgram setCount:aCount];
    [mParticleProgram setSpeed:aSpeed];
    [mParticleProgram reset];
    [mParticleProgram setCompletionBlock:^{
        [mEffectNode setSubNodes:nil];
    }];
 
    NSInteger  sTextureIndex = arc4random() % 3;
    NSArray   *sImageNames   = [NSArray arrayWithObjects:@"CN_perpectflare_red.png", @"CN_perpectflare_green.png", @"CN_perpectflare_blue.png", nil];
    PBTexture *sTexture      = [[[PBTexture alloc] initWithImageName:[sImageNames objectAtIndex:sTextureIndex]] autorelease];
    [sTexture loadIfNeeded];
    PBSpriteNode *sParticleSprite = [[[PBSpriteNode alloc] initWithTexture:sTexture] autorelease];
    [mEffectNode setSubNodes:[NSArray arrayWithObjects:sParticleSprite, nil]];
}


#pragma mark -


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
    [[ProfilingOverlay sharedManager] displayFPS:[self fps] timeInterval:[self timeInterval]];
    if ([[mEffectNode subNodes] count])
    {
        [mParticleProgram update];
    }
}


@end
