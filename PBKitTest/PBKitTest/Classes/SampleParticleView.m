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
#import "RainParticleProgram.h"
#import "SpurtParticleProgram.h"


@implementation SampleParticleView
{
    PBScene               *mScene;
    PBEffectNode          *mEffectNode;
    ParticleSelectType     mType;

    RadialParticleProgram *mRadialProgram;
    FlameParticleProgram  *mFlameProgram;
    RainParticleProgram   *mRainProgram;
    SpurtParticleProgram  *mSpurtProgram;
}


@synthesize type = mType;


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self)
    {
        mScene = [[PBScene alloc] initWithDelegate:self];
        [self setBackgroundColor:[PBColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f]];
        [self presentScene:mScene];
        
        PBSpriteNode *sBackground = [[[PBSpriteNode alloc] initWithImageNamed:@"zombie_background"] autorelease];
        mRadialProgram = [[RadialParticleProgram alloc] init];
        mFlameProgram  = [[FlameParticleProgram alloc] init];
        mRainProgram   = [[RainParticleProgram alloc] init];
        mSpurtProgram  = [[SpurtParticleProgram alloc] init];
        
        mEffectNode    = [[PBEffectNode alloc] init];
        [mScene setSubNodes:[NSArray arrayWithObjects:sBackground, mEffectNode, nil]];
        
        mType = kSelectParticleNone;
    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    [mSpurtProgram release];
    [mRadialProgram release];
    [mFlameProgram release];
    [mRainProgram release];
    [mEffectNode release];
    [mScene release];
    
    [super dealloc];
}


#pragma mark -


- (void)radial
{
    PBParticleEmitter sEmitter = initEmitter();
    sEmitter.currentSpan           = 0;
    sEmitter.count                 = 500;
    sEmitter.lifeSpan              = 1.0f;
    sEmitter.startPosition         = PBVertex3Make(0.0, 0.0, 2.0);
    sEmitter.startPositionVariance = PBVertex3Make(0.0, 0.0, 0.0);
    sEmitter.endPosition           = PBVertex3Make(0.0, 0.0, 1.0);
    sEmitter.endPositionVariance   = PBVertex3Make(1.0, 1.0, 0.0);
    sEmitter.speed                 = 0.02;
    sEmitter.zoomScale             = 1.0f;
    sEmitter.loop                  = true;
    [mRadialProgram setEmitter:sEmitter arrangeData:YES];

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
    PBParticleEmitter sEmitter = initEmitter();
    sEmitter.currentSpan           = 0;
    sEmitter.count                 = 80;
    sEmitter.lifeSpan              = 2.0f;
    sEmitter.startPosition         = PBVertex3Make(0.0, 0.0, 0.0);
    sEmitter.startPositionVariance = PBVertex3Make(0.0, 0.0, 0.0);
    sEmitter.endPosition           = PBVertex3Make(0.0, 1.0, 0.0);
    sEmitter.endPositionVariance   = PBVertex3Make(0.2, 0.1, 0.0);
    sEmitter.speed                 = 0.05;
    sEmitter.zoomScale             = 1.0f;
    sEmitter.loop                  = true;
    [mFlameProgram setEmitter:sEmitter arrangeData:YES];
    
    PBSpriteNode *sParticleSprite = [[[PBSpriteNode alloc] initWithImageNamed:@"particle"] autorelease];
    [mEffectNode setSubNodes:[NSArray arrayWithObjects:sParticleSprite, nil]];
    [mEffectNode setProgram:mFlameProgram];
}


- (void)rain
{
    PBParticleEmitter sEmitter = initEmitter();
    sEmitter.currentSpan           = 0;
    sEmitter.count                 = 200;
    sEmitter.lifeSpan              = 3.0f;
    sEmitter.viewPortWidth         = 1;
    sEmitter.viewPortHeight        = 1;
    sEmitter.startPosition         = PBVertex3Make(0.0, 200.0, 1.0);
    sEmitter.startPositionVariance = PBVertex3Make(160.0, 0.0, 0.0);
    sEmitter.endPosition           = PBVertex3Make(0.0, -350.0, 0.0);
    sEmitter.endPositionVariance   = PBVertex3Make(10.0, 0.0, 0.0);
    sEmitter.speed                 = 0.13;
    sEmitter.zoomScale             = 1.0f;
    sEmitter.loop                  = true;
    [mRainProgram setEmitter:sEmitter arrangeData:YES];
    
    PBSpriteNode *sParticleSprite = [[[PBSpriteNode alloc] initWithImageNamed:@"raindrop_particle"] autorelease];
    [mEffectNode setSubNodes:[NSArray arrayWithObjects:sParticleSprite, nil]];
    [mEffectNode setProgram:mRainProgram];
}


- (void)spurt
{
    PBParticleEmitter sEmitter = initEmitter();
    sEmitter.currentSpan           = 0;
    sEmitter.count                 = 50;
    sEmitter.lifeSpan              = 1.0f;
    sEmitter.startPosition         = PBVertex3Make(0.0, 0.0, 2.0);
    sEmitter.startPositionVariance = PBVertex3Make(0.0, 0.0, 0.0);
    sEmitter.endPosition           = PBVertex3Make(0.0, -0.5, 1.0);
    sEmitter.endPositionVariance   = PBVertex3Make(0.5, 0.5, 0.0);
    sEmitter.speed                 = 0.04;
    sEmitter.zoomScale             = 1.0f;
    sEmitter.loop                  = false;
    [mSpurtProgram setEmitter:sEmitter arrangeData:YES];
    
    PBSpriteNode *sParticleSprite = [[[PBSpriteNode alloc] initWithImageNamed:@"particle"] autorelease];
    [mEffectNode setSubNodes:[NSArray arrayWithObjects:sParticleSprite, nil]];
    [mEffectNode setProgram:mSpurtProgram];
}


#pragma mark -


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
    [[ProfilingOverlay sharedManager] displayFPS:[self fps] timeInterval:[self timeInterval]];
    if ([[mEffectNode subNodes] count])
    {
        switch (mType)
        {
            case kSelectParticlRadial:
                [mRadialProgram update];
                break;
            case kSelectParticleFlame:
                [mFlameProgram update];
                break;
            case kSelectParticleRain:
                [mRainProgram update];
                break;
            case kSelectParticleSpurt:
                [mSpurtProgram update];
                break;
            default:
                break;
        }
    }
}


@end
