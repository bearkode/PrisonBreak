/*
 *  FXEffectViewController.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 5. 28..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "FXEffectViewController.h"
#import <PBKit.h>
#import "ProfilingOverlay.h"
#import "RippleSceneProgram.h"
#import "ShockwaveSceneProgram.h"
#import "LightingProgram.h"
#import "LaserProgram.h"


typedef enum
{
    kFXEffectTypeOff = 0,
    kFXEffectTypeRipple,
    kFXEffectTypeShockwave,
    kFXEffectTypeLightning,
    kFXEffectTypeLaser
} FXEffectType;


@implementation FXEffectViewController
{
    PBScene               *mScene;
    
    // scene effect
    RippleSceneProgram    *mRippleSceneProgram;
    ShockwaveSceneProgram *mShockwaveProgram;
    
    // node effect
    PBEffectNode          *mEffectNode;
    LightingProgram       *mLightningProgram;
    LaserProgram          *mLaserProgram;
    
    NSMutableArray       *mLandscapeNodeArray;
    UIView               *mControlPannel;
    PBSpriteNode         *mSampleSprite2;
    NSInteger             mSelectedEffectType;
}


#pragma mark -


- (void)updateLandscape
{
    CGPoint sPoint = CGPointZero;
    for (PBSpriteNode *sNode in mLandscapeNodeArray)
    {
        sPoint = [sNode point];
        sPoint.x += 3.0;
        
        if (sPoint.x > 320)
        {
            sPoint.x = -320;
        }
        [sNode setPoint:sPoint];
    }
    
    sPoint = [mSampleSprite2 point];
    sPoint.x += 5.0f;
    if (sPoint.x > 160)
        sPoint.x = -160;
    
    [mSampleSprite2 setPoint:sPoint];
}


#pragma mark -


- (void)setupLandscape
{
    mLandscapeNodeArray = [[NSMutableArray alloc] init];
    PBTexture *sLandscapeTexture  = [PBTextureManager textureWithImageName:@"zombie_background"];
    [sLandscapeTexture loadIfNeeded];
    for (NSInteger i = 0; i < 2; i++)
    {
        PBSpriteNode *sNode = [[[PBSpriteNode alloc] initWithTexture:sLandscapeTexture] autorelease];
        
        CGPoint sPoint = (i == 0) ? CGPointMake(0, 0) : CGPointMake(-320, 0);
        [sNode setPoint:sPoint];
        
        [mLandscapeNodeArray addObject:sNode];
    }
    
    [mScene addSubNodes:mLandscapeNodeArray];
    
    mSampleSprite2 = [[[PBSpriteNode alloc] initWithImageNamed:@"poket0118"] autorelease];
    [mSampleSprite2 setPoint:CGPointMake(0, 100)];
    
    [mScene addSubNode:mSampleSprite2];
}


- (void)setupControlUI
{
    UISegmentedControl *sEffectOnSegment = [[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Off", @"Ripple", @"Shockwave", @"Lightning", @"Laser", nil]] autorelease];
    [sEffectOnSegment setFrame:CGRectMake(0, 5, 320, 30)];
    [sEffectOnSegment addTarget:self action:@selector(renderSelected:)forControlEvents:UIControlEventValueChanged];
    [sEffectOnSegment setSelectedSegmentIndex:0];
    [sEffectOnSegment setSegmentedControlStyle:UISegmentedControlStyleBar];
    [sEffectOnSegment setAlpha:0.7];
    [[self view] addSubview:sEffectOnSegment];
}


#pragma mark -


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[self view] setBackgroundColor:[UIColor darkGrayColor]];
    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
 
    [mScene release];
    [mEffectNode release];
    [mLandscapeNodeArray release];
    [mShockwaveProgram release];
    [mRippleSceneProgram release];
    [mLightningProgram release];
    [mLaserProgram release];    
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mScene = [[PBScene alloc] initWithDelegate:self];
    [[self canvas] presentScene:mScene];
    
    [self setupLandscape];
    [self setupControlUI];

    mRippleSceneProgram = [[RippleSceneProgram alloc] init];
    [mRippleSceneProgram setCamera:[[self canvas] camera]];
    
    mShockwaveProgram = [[ShockwaveSceneProgram alloc] init];
    [mShockwaveProgram setCamera:[[self canvas] camera]];
    
    mLightningProgram = [[LightingProgram alloc] init];
    [mLightningProgram setCamera:[[self canvas] camera]];
    
    mLaserProgram = [[LaserProgram alloc] init];
    [mLaserProgram setCamera:[[self canvas] camera]];
    
    mEffectNode   = [[PBEffectNode alloc] init];
    PBNode *sNode = [[[PBNode alloc] init] autorelease];
    [mEffectNode addSubNode:sNode];
    [mScene addSubNode:mEffectNode];
    

}


#pragma mark -


- (void)renderSelected:(UISegmentedControl *)aSender
{
    mSelectedEffectType = [aSender selectedSegmentIndex];
    
    switch (mSelectedEffectType)
    {
        case kFXEffectTypeLightning:
            [mEffectNode setProgram:mLightningProgram];
            break;
        case kFXEffectTypeLaser:
            [mEffectNode setProgram:mLaserProgram];
            break;
        default:
            [mEffectNode setProgram:nil];
            break;
    }
}


#pragma mark -


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
    [[ProfilingOverlay sharedManager] displayFPS:[[self canvas] fps] timeInterval:[[self canvas] timeInterval]];

    [self updateLandscape];
}


- (void)pbScene:(PBScene *)aScene didTapCanvasPoint:(CGPoint)aCanvasPoint
{
    switch (mSelectedEffectType)
    {
        case kFXEffectTypeOff:
            break;
        case kFXEffectTypeRipple:
            [mRippleSceneProgram setPoint:aCanvasPoint];
            break;
        case kFXEffectTypeShockwave:
            [mShockwaveProgram setPoint:aCanvasPoint];
            [mShockwaveProgram setTime:0.0];
            break;
        case kFXEffectTypeLightning:
            [mLightningProgram setStartPoint:CGPointMake(0, 170)];
            [mLightningProgram setEndPoint:aCanvasPoint];
            [mLightningProgram fire];
            break;
        case kFXEffectTypeLaser:
            [mLaserProgram setStartPoint:CGPointMake(0, 170)];
            [mLaserProgram setEndPoint:aCanvasPoint];
            [mLaserProgram fire];
            break;
        default:
            break;
    }
}


- (void)pbSceneWillRender:(PBScene *)aScene
{
    switch (mSelectedEffectType)
    {
        case kFXEffectTypeOff:
            break;
        case kFXEffectTypeRipple:
            [mRippleSceneProgram update:[aScene textureHandle]];
            break;
        case kFXEffectTypeShockwave:
            [mShockwaveProgram update:[aScene textureHandle]];
            break;
        default:
            break;
    }
}


@end
