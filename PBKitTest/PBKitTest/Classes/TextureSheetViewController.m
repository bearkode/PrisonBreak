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
#import "Explosion.h"
#import "ProfilingOverlay.h"


@implementation TextureSheetViewController
{
    PBCanvas        *mCanvas;
    PBScene         *mScene;

    PBTileSprite    *mBoom;
    FrameRateLabel  *mFrameRateLabel;
    PBDrawingSprite *mIndexLabel;
    PBSprite        *mVertex1;
    PBSprite        *mVertex2;
    PBSprite        *mVertex3;
    PBSprite        *mVertex4;
    PBSprite        *mAirship;
    
    NSMutableArray  *mUsingExplosions;
    NSMutableArray  *mSurplusExplosions;
    
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
        mBoom = [[PBTileSprite alloc] initWithImageName:@"exp1" tileSize:CGSizeMake(64, 64)];
        
        mIndexLabel = [[PBDrawingSprite alloc] initWithSize:CGSizeMake(80, 20)];
        [mIndexLabel setDelegate:self];
        
        mFrameRateLabel = [[FrameRateLabel alloc] initWithSize:CGSizeMake(150, 20)];
        
        mVertex1 = [[PBSprite alloc] initWithImageName:@"poket0000"];
        mVertex2 = [[PBSprite alloc] initWithImageName:@"poket0001"];
        mVertex3 = [[PBSprite alloc] initWithImageName:@"poket0002"];
        mVertex4 = [[PBSprite alloc] initWithImageName:@"poket0003"];
        mAirship = [[PBSprite alloc] initWithImageName:@"airship"];
        
        mUsingExplosions   = [[NSMutableArray alloc] init];
        mSurplusExplosions = [[NSMutableArray alloc] init];
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
    
    [mUsingExplosions release];
    [mSurplusExplosions release];
    
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
    
    PBVertex3 sAngle = [[mVertex1 transform] angle];
    sAngle.z += 3;
    [[mVertex1 transform] setAngle:sAngle];
    [[mVertex2 transform] setAngle:sAngle];
    [[mVertex3 transform] setAngle:sAngle];
    [[mVertex4 transform] setAngle:sAngle];
    
    if (mTextureIndex > 0)
    {
        [mBoom setHidden:NO];
        [mBoom selectSpriteAtIndex:mTextureIndex];
    }
    
    mTextureIndex++;
    
    if (mTextureIndex > 24)
    {
        [mBoom setHidden:YES];
        mTextureIndex = -25;
    }
    
    NSMutableArray *sTempArray = [NSMutableArray array];
    for (Explosion *sExplosion in mUsingExplosions)
    {
        if (![sExplosion update])
        {
            [sTempArray addObject:sExplosion];
            [sExplosion removeFromSuperNode];
        }
    }
    [mUsingExplosions removeObjectsInArray:sTempArray];
    [mSurplusExplosions addObjectsFromArray:sTempArray];

    [mIndexLabel refresh];
    
    mFrameCount++;
}


- (void)pbScene:(PBScene *)aScene didTapCanvasPoint:(CGPoint)aCanvasPoint
{
    Explosion *sExplosion = nil;
    
    if ([mSurplusExplosions count])
    {
        sExplosion = [[mSurplusExplosions lastObject] retain];
        [mSurplusExplosions removeLastObject];
    }
    else
    {
        sExplosion = [[Explosion alloc] init];
    }
    
    [mUsingExplosions addObject:sExplosion];
    [mScene addSubNode:sExplosion];

    [sExplosion setPoint:aCanvasPoint];
    [sExplosion release];
}


- (void)timerExpired:(NSTimer *)aTimer
{
    [mFrameRateLabel setFrameRate:(CGFloat)mFrameCount];    
    mFrameCount = 0;
}


- (void)sprite:(PBDrawingSprite *)aSprite drawInRect:(CGRect)aRect context:(CGContextRef)aContext
{
    if (aSprite == mIndexLabel)
    {
        NSString *sText  = [NSString stringWithFormat:@"INDEX = %d", mTextureIndex];
        CGFloat   sScale = [[mIndexLabel texture] imageScale];
        
        CGContextClearRect(aContext, aRect);

#if (0)
        CGContextSetFillColorWithColor(aContext, [[UIColor redColor] CGColor]);
        CGContextFillRect(aContext, aRect);
#endif
        
        CGContextSelectFont(aContext, "MarkerFelt-Thin", 16 * sScale, kCGEncodingMacRoman);
        CGContextSetTextDrawingMode(aContext, kCGTextFill);
        
        CGContextSetFillColorWithColor(aContext, [[UIColor lightGrayColor] CGColor]);
        CGContextShowTextAtPoint(aContext, 1 * sScale, 5 * sScale, [sText UTF8String], strlen([sText UTF8String]));
        
        CGContextSetFillColorWithColor(aContext, [[UIColor whiteColor] CGColor]);
        CGContextShowTextAtPoint(aContext, 0 * sScale, 6 * sScale, [sText UTF8String], strlen([sText UTF8String]));
    }
}


@end
