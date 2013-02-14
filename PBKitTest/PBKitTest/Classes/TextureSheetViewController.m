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
#import "IndexTexture.h"
#import "Explosion.h"


@implementation TextureSheetViewController
{
    PBView          *mView;

    PBTileSprite    *mBoom;
    PBDrawingSprite *mIndexLabel;
    PBSprite        *mVertex1;
    PBSprite        *mVertex2;
    PBSprite        *mVertex3;
    PBSprite        *mVertex4;
    PBSprite        *mAirship;
    
    NSMutableArray  *mUsingExplosions;
    NSMutableArray  *mSurplusExplosions;
    
    NSInteger        mTextureIndex;
    CGFloat          mFPS;
}


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    
    if (self)
    {
        mTextureIndex = 0;
        mBoom = [[PBTileSprite alloc] initWithImageName:@"exp1" tileSize:CGSizeMake(64, 64)];
        
        mIndexLabel = [[PBDrawingSprite alloc] initWithSize:CGSizeMake(170, 20)];
        [mIndexLabel setDelegate:self];
        
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
    [mBoom release];
    [mIndexLabel release];
    
    [mVertex1 release];
    [mVertex2 release];
    [mVertex3 release];
    [mVertex4 release];
    
    [mAirship release];
    
    [mUsingExplosions release];
    [mSurplusExplosions release];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mView = [[[PBView alloc] initWithFrame:[[self view] bounds]] autorelease];
    [mView setDelegate:self];
    [mView setDisplayFrameRate:kPBDisplayFrameRateHeigh];
    [mView setBackgroundColor:[PBColor blackColor]];
    [mView registGestureEvent];
    [mView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [[self view] addSubview:mView];
    
    [[mView renderable] setSubrenderables:[NSArray arrayWithObjects:mBoom, mIndexLabel, mVertex1, mVertex2, mVertex3, mVertex4, mAirship, nil]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    mView = nil;
}


- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];

    CGRect  sBounds = [[self view] bounds];
    CGFloat sScale  = [[UIScreen mainScreen] scale];
    
    sBounds.origin.x    *= sScale;
    sBounds.origin.y    *= sScale;
    sBounds.size.width  *= sScale;
    sBounds.size.height *= sScale;
    
    [mVertex1 setPosition:CGPointMake(sBounds.origin.x, sBounds.origin.y)];
    [mVertex2 setPosition:CGPointMake(sBounds.origin.x + sBounds.size.width, sBounds.origin.y)];
    [mVertex3 setPosition:CGPointMake(sBounds.origin.x, sBounds.origin.y + sBounds.size.height)];
    [mVertex4 setPosition:CGPointMake(sBounds.origin.x + sBounds.size.width, sBounds.origin.y + sBounds.size.height)];
    
    [mBoom setPosition:CGPointMake(sBounds.size.width / 2, sBounds.size.height / 2)];
    [mIndexLabel setPosition:CGPointMake(sBounds.size.width / 2, sBounds.size.height / 2 - 40 * sScale)];
    
    [mAirship setPosition:CGPointMake(sBounds.size.width / 2, 350 * sScale)];

    [[mView camera] setPosition:CGPointMake(sBounds.size.width / 2, sBounds.size.height / 2)];
    [[mView camera] setZoomScale:1.0];
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    [mView startDisplayLoop];
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
    
    [mView stopDisplayLoop];
}



#pragma mark -


- (void)pbViewUpdate:(PBView *)aView timeInterval:(CFTimeInterval)aTimeInterval displayLink:(CADisplayLink *)aDisplayLink
{
    PBVertex3 sAngle = [mVertex1 angle];
    sAngle.z += 3;
    [mVertex1 setAngle:sAngle];
    [mVertex2 setAngle:sAngle];
    [mVertex3 setAngle:sAngle];
    [mVertex4 setAngle:sAngle];
    
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
            [sExplosion removeFromSuperrenderable];
        }
    }
    [mUsingExplosions removeObjectsInArray:sTempArray];
    [mSurplusExplosions addObjectsFromArray:sTempArray];

    
    mFPS = 1.0 / aTimeInterval;
    [mIndexLabel refresh];
}


- (void)pbView:(PBView *)aView didTapPoint:(CGPoint)aPoint
{
    CGPoint sPoint = [mView convertPointFromView:aPoint];
    
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
    [[mView renderable] addSubrenderable:sExplosion];

    [sExplosion setPosition:sPoint];
    [sExplosion release];
}


- (void)sprite:(PBDrawingSprite *)aSprite drawInRect:(CGRect)aRect context:(CGContextRef)aContext
{
    if (aSprite == mIndexLabel)
    {
        NSString *sText  = [NSString stringWithFormat:@"INDEX = %d : %2.1f FPS", mTextureIndex, mFPS];
        CGFloat   sScale = [mIndexLabel scale];
        
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
