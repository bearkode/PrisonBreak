/*
 *  TextureSheetViewController.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 2. 4..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "TextureSheetViewController.h"
#import <PBKit.h>
#import "FrameRateLabel.h"
#import "IndexLabel.h"
#import "ProfilingOverlay.h"


@implementation TextureSheetViewController
{
    PBCanvas        *mCanvas;
    PBScene         *mScene;

    PBSpriteNode    *mBoom;
    FrameRateLabel  *mFrameRateLabel;
    IndexLabel      *mIndexLabel;
    PBSpriteNode    *mVertex1;
    PBSpriteNode    *mVertex2;
    PBSpriteNode    *mVertex3;
    PBSpriteNode    *mVertex4;
    PBSpriteNode    *mAirship;
    
    NSInteger        mTextureIndex;
    NSTimer         *mTimer;
    NSInteger        mFrameCount;
}


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    
    if (self)
    {
        mTextureIndex = 0;
        mBoom = [[PBSpriteNode alloc] initWithImageNamed:@"exp1"];
        [mBoom setTileSize:CGSizeMake(64, 64)];
        
        mIndexLabel     = [[IndexLabel alloc] initWithSize:CGSizeMake(80, 20)];
        mFrameRateLabel = [[FrameRateLabel alloc] init];
        
        mVertex1 = [[PBSpriteNode alloc] initWithImageNamed:@"poket0000"];
        mVertex2 = [[PBSpriteNode alloc] initWithImageNamed:@"poket0001"];
        mVertex3 = [[PBSpriteNode alloc] initWithImageNamed:@"poket0002"];
        mVertex4 = [[PBSpriteNode alloc] initWithImageNamed:@"poket0003"];
        mAirship = [[PBSpriteNode alloc] initWithImageNamed:@"airship"];
    }
    
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    
    [mScene release];
    [mBoom release];
    [mIndexLabel release];
    [mFrameRateLabel release];
    
    [mVertex1 release];
    [mVertex2 release];
    [mVertex3 release];
    [mVertex4 release];
    
    [mAirship release];
    
    [PBTextureManager vacate];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect sBounds = [[self view] bounds];
    
    mCanvas = [[[PBCanvas alloc] initWithFrame:sBounds] autorelease];

    mScene = [[PBScene alloc] initWithDelegate:self];
    [mCanvas presentScene:mScene];

    [mCanvas setDisplayFrameRate:kPBDisplayFrameRateHigh];
    [mCanvas setBackgroundColor:[PBColor blackColor]];
    [mCanvas setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [[self view] addSubview:mCanvas];
    
    [mScene setSubNodes:[NSArray arrayWithObjects:mBoom, mIndexLabel, mVertex1, mVertex2, mVertex3, mVertex4, mAirship, mFrameRateLabel, nil]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    mCanvas = nil;
}


- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];

    CGRect  sBounds = [[self view] bounds];
    
    [[mCanvas camera] setPosition:CGPointMake(sBounds.size.width / 2, sBounds.size.height / 2)];
    [[mCanvas camera] setZoomScale:1.0];
    
    [mVertex1 setPoint:CGPointMake(sBounds.origin.x, sBounds.origin.y)];
    [mVertex2 setPoint:CGPointMake(sBounds.origin.x + sBounds.size.width, sBounds.origin.y)];
    [mVertex3 setPoint:CGPointMake(sBounds.origin.x, sBounds.origin.y + sBounds.size.height)];
    [mVertex4 setPoint:CGPointMake(sBounds.origin.x + sBounds.size.width, sBounds.origin.y + sBounds.size.height)];
    
    [mBoom setPoint:CGPointMake(sBounds.size.width / 2, sBounds.size.height / 2)];
    [mBoom selectTileAtIndex:1];
    
    [mIndexLabel setPoint:CGPointMake(sBounds.size.width / 2, sBounds.size.height / 2 - 40)];

    [mFrameRateLabel setPoint:CGPointMake(60, 20)];
    
    [mAirship setPoint:CGPointMake(sBounds.size.width / 2, 350)];
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    [mCanvas startDisplayLoop];
    
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerExpired:) userInfo:nil repeats:YES];    
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
    
    [mCanvas stopDisplayLoop];
    
    [mTimer invalidate];
    [PBTextureManager vacate];
}



#pragma mark -


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
    [[ProfilingOverlay sharedManager] displayFPS:[mCanvas fps] timeInterval:[mCanvas timeInterval]];
    
    PBVertex3 sAngle = [mVertex1 angle];
    sAngle.z += 3;
    [mVertex1 setAngle:sAngle];
    [mVertex2 setAngle:sAngle];
    [mVertex3 setAngle:sAngle];
    [mVertex4 setAngle:sAngle];
    
    if (mTextureIndex >= 0)
    {
        [mBoom setHidden:NO];
        [mBoom selectTileAtIndex:mTextureIndex];
    }
    
    mTextureIndex++;
    
    if (mTextureIndex > 24)
    {
        [mBoom setHidden:YES];
        mTextureIndex = -25;
    }
    
    [mIndexLabel setTextureIndex:mTextureIndex];
    
    mFrameCount++;
}


- (void)timerExpired:(NSTimer *)aTimer
{
    [mFrameRateLabel setFrameRate:(CGFloat)mFrameCount];    
    mFrameCount = 0;
}


@end
