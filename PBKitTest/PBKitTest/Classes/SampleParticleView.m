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
#import "FlameParticleProgram.h"


typedef enum
{
    kSelectParticleNone = 0,
    kSelectParticlRadial,
    kSelectParticleFlame,
} ParticleSelectType;


@implementation SampleParticleView
{
    PBScene               *mScene;
    PBEffectNode          *mEffectNode;
    RadialParticleProgram *mRadialProgram;
    FlameParticleProgram  *mFlameProgram;
    ParticleSelectType     mSelectType;
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
        mRadialProgram = [[RadialParticleProgram alloc] init];
        mFlameProgram  = [[FlameParticleProgram alloc] init];
        
        mEffectNode    = [[PBEffectNode alloc] init];
        [mScene setSubNodes:[NSArray arrayWithObjects:sBackground, mEffectNode, nil]];
        
        mSelectType    = kSelectParticleNone;
    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    [mRadialProgram release];
    [mFlameProgram release];
    [mEffectNode release];
    [mScene release];
    
    [super dealloc];
}


#pragma mark -


- (void)radial
{
    mSelectType = kSelectParticlRadial;
    
    PBParticleEmitter sEmitter;
    sEmitter.currentSpan           = 0;
    sEmitter.count                 = 500;
    sEmitter.lifeSpan              = 1.0f;
    sEmitter.startPosition         = PBVertex3Make(0, 0, 0);
    sEmitter.startPositionVariance = PBVertex3Make(0.0, 0.0, 0);
    sEmitter.endPosition           = PBVertex3Make(0.0, 0.0, 0);
    sEmitter.endPositionVariance   = PBVertex3Make(1.0, 1.0, 0);
    sEmitter.speed                 = 0.02;
    sEmitter.loop                  = true;
    [mRadialProgram setEmitter:sEmitter];

//    [mRadialProgram setEmitterCompletionBlock:^{
//        [mEffectNode setSubNodes:nil];
//    }];
 
    NSInteger  sTextureIndex = arc4random() % 3;
    NSArray   *sImageNames   = [NSArray arrayWithObjects:@"CN_perpectflare_red.png", @"CN_perpectflare_green.png", @"CN_perpectflare_blue.png", nil];
    PBTexture *sTexture      = [[[PBTexture alloc] initWithImageName:[sImageNames objectAtIndex:sTextureIndex]] autorelease];
    [sTexture loadIfNeeded];
    PBSpriteNode *sParticleSprite = [[[PBSpriteNode alloc] initWithTexture:sTexture] autorelease];
    [mEffectNode setSubNodes:[NSArray arrayWithObjects:sParticleSprite, nil]];
    [mEffectNode setProgram:mRadialProgram];
}


- (void)flame
{
    mSelectType = kSelectParticleFlame;
    
    PBParticleEmitter sEmitter;
    sEmitter.currentSpan           = 0;
    sEmitter.count                 = 80;
    sEmitter.lifeSpan              = 2.0f;
    sEmitter.startPosition         = PBVertex3Make(0, 0, 0);
    sEmitter.startPositionVariance = PBVertex3Make(0.0, 0.0, 0);
    sEmitter.endPosition           = PBVertex3Make(0.0, 1.0, 0);
    sEmitter.endPositionVariance   = PBVertex3Make(0.2, 0.1, 0);
    sEmitter.speed                 = 0.05;
    sEmitter.loop                  = true;
    [mFlameProgram setEmitter:sEmitter];
    
    PBSpriteNode *sParticleSprite = [[[PBSpriteNode alloc] initWithImageNamed:@"particle"] autorelease];
    [mEffectNode setSubNodes:[NSArray arrayWithObjects:sParticleSprite, nil]];
    [mEffectNode setProgram:mFlameProgram];
}

#pragma mark -


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
    [[ProfilingOverlay sharedManager] displayFPS:[self fps] timeInterval:[self timeInterval]];
    if ([[mEffectNode subNodes] count])
    {
        switch (mSelectType)
        {
            case kSelectParticlRadial:
                [mRadialProgram update];
                break;
            case kSelectParticleFlame:
                [mFlameProgram update];
                break;
            default:
                break;
        }
    }
}


@end
