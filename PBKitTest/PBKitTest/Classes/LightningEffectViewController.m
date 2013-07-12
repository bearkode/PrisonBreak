/*
 *  LightningEffectViewController.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 11..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBKit.h>
#import "LightningEffectViewController.h"
#import "LightingProgram.h"


typedef struct {
    GLint projectionLoc;
    GLint positionLoc;
    GLint texCoordLoc;
    GLint resolutionLoc;
    GLint pointLoc;
    GLint timeLoc;
    GLint paramLoc;
} LightningLocation;


@implementation LightningEffectViewController
{
    LightingProgram   *mProgram;
    LightningLocation  mLocation;
    PBEffectNode      *mEffectNode;
    PBNode            *mLightningNode;
}


#pragma mark -


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}


- (void)dealloc
{
    [mProgram release];
    [mEffectNode release];
    [mLightningNode release];
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PBScene *sScene = [[PBScene alloc] initWithDelegate:self];
    [[self canvas] presentScene:sScene];
    [[self canvas] setBackgroundColor:[PBColor colorWithRed:1.0f green:0.3f blue:0.3f alpha:1.0f]];

    mProgram = [[LightingProgram alloc] init];
    
    PBSpriteNode *sBackground = [[[PBSpriteNode alloc] initWithImageNamed:@"zombie_background"] autorelease];
    mEffectNode               = [[PBEffectNode alloc] init];
    mLightningNode            = [[PBNode alloc] init];
    [mEffectNode addSubNode:mLightningNode];
    [mEffectNode setProgram:mProgram];
    

    [sScene setSubNodes:[NSArray arrayWithObjects:sBackground, mLightningNode, nil]];
}


#pragma mark -


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
}


- (void)pbScene:(PBScene *)aScene didTapCanvasPoint:(CGPoint)aCanvasPoint
{
}


@end