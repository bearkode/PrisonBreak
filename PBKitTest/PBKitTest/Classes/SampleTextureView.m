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
    
    PBNode       *mScreen;
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
        
        mScreen = [[PBNode alloc] init];
        [mScreen setName:@"screen"];
        [mScreen setPoint:CGPointMake(-20, 0)];
        
        
        [mAirship setSubNodes:[NSArray arrayWithObjects:mPoket1, mPoket2, nil]];
        [mScreen setSubNodes:[NSArray arrayWithObjects:mAirship, nil]];
        
        [sScene setSubNodes:[NSArray arrayWithObjects:mAirship, nil]];
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
    
    [mScreen release];
    
    [super dealloc];
}


#pragma mark -


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
    [[ProfilingOverlay sharedManager] displayFPS:[self fps] timeInterval:[self timeInterval]];
    
    [mAirship setScale:[self scale]];
    [mAirship setAngle:PBVertex3Make(0, 0, [self angle])];
    [mAirship setAlpha:[self alpha]];
    
    [mPoket2 setScale:[self scale]];
    [mPoket2 setAngle:PBVertex3Make(0, 0, [self angle] * 3)];
    [mPoket2 setAlpha:[self alpha]];
    
    [mCoin setScale:[self scale]];
    [mCoin setAngle:PBVertex3Make(0, 0, [self angle])];
    [mCoin setAlpha:[self alpha]];
    
    [mAirship setGrayscale:mGrayScale];
    [mPoket1 setGrayscale:mGrayScale];
    [mPoket2 setGrayscale:mGrayScale];
    
    [mAirship setSepia:mSepia];
    [mPoket1 setSepia:mSepia];
    [mPoket2 setSepia:mSepia];
    
    [mAirship setBlur:mBlur];
    [mPoket1 setBlur:mBlur];
    [mPoket2 setBlur:mBlur];
    
    [mAirship setLuminance:mLuminance];
    [mPoket1 setLuminance:mLuminance];
    [mPoket2 setLuminance:mLuminance];
}


@end
