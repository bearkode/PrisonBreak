/*
 *  SampleTextureView.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 21..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "SampleTextureView.h"
#import <PBKit.h>
#import "ProfilingOverlay.h"


@implementation SampleTextureView
{
    PBSpriteNode *mAirship;
    PBSpriteNode *mPoket1;
    PBSpriteNode *mPoket2;
    PBSpriteNode *mCoin;
}


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self)
    {
        PBScene *sScene = [[[PBScene alloc] initWithDelegate:self] autorelease];
        [self presentScene:sScene];

        [self setBackgroundColor:[PBColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
        
        mAirship = [[PBSpriteNode alloc] initWithImageNamed:@"airship"];
        mPoket1  = [[PBSpriteNode alloc] initWithImageNamed:@"poket0118"];
        mPoket2  = [[PBSpriteNode alloc] initWithImageNamed:@"poket0119"];
        
        [mAirship setName:@"airship"];
        [mPoket1 setName:@"poket0118"];
        [mPoket2 setName:@"poket0119"];

        [mAirship setPoint:CGPointMake(-40, 0)];
        [mPoket1 setPoint:CGPointMake(-80, 0)];
        [mPoket2 setPoint:CGPointMake(40, 20)];
        
        [mAirship setZPoint:1.0f];
        
        [mAirship setSubNodes:[NSArray arrayWithObjects:mPoket1, mPoket2, nil]];

        [sScene setSubNodes:[NSArray arrayWithObjects:mAirship, nil]];
        
        
//        PBSpriteNode *sSprite1 = [[PBSpriteNode alloc] initWithImageNamed:@"poket0118"];
//        
//        PBSpriteNode *sSprite2 = [[PBSpriteNode alloc] initWithImageNamed:@"poket0117"];
//        [sSprite2 setPoint:CGPointMake(30, 30)];
//        [sSprite1 addSubNode:sSprite2];
//
//        PBSpriteNode *sSprite3 = [[PBSpriteNode alloc] initWithImageNamed:@"poket0117"];
//        [sSprite3 setPoint:CGPointMake(30, 30)];
//        [sSprite2 addSubNode:sSprite3];
//        
//        PBSpriteNode *sSprite4 = [[PBSpriteNode alloc] initWithImageNamed:@"poket0118"];
//        [sSprite4 setPoint:CGPointMake(30, 30)];
//        [sSprite3 addSubNode:sSprite4];
//
//        [sScene setSubNodes:[NSArray arrayWithObjects:sSprite1, nil]];
    }
    
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    
    [mAirship release];
    [mPoket1 release];
    [mPoket2 release];
    [mCoin release];
    
    [super dealloc];
}


#pragma mark -


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
    [[ProfilingOverlay sharedManager] displayFPS:[self fps] timeInterval:[self timeInterval]];
    
    [mAirship setScale:PBVertex3Make([self scaleX], [self scaleY], 1.0f)];
    [mAirship setAngle:PBVertex3Make(0, 0, [self angle])];
    [mAirship setAlpha:[self alpha]];
    
    [mPoket2 setScale:PBVertex3Make([self scaleX], [self scaleY], 1.0f)];
    [mPoket2 setAngle:PBVertex3Make(0, 0, [self angle] * 3)];
    [mPoket2 setAlpha:[self alpha]];
    
    [mCoin setScale:PBVertex3Make([self scaleX], [self scaleY], 1.0f)];
    [mCoin setAngle:PBVertex3Make(0, 0, [self angle])];
    [mCoin setAlpha:[self alpha]];
}


@end
