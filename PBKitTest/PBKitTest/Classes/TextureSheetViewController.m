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
    PBView         *mView;

    PBRenderable   *mBoom;
    PBRenderable   *mIndexLabel;
    PBRenderable   *mVertex1;
    PBRenderable   *mVertex2;
    PBRenderable   *mVertex3;
    PBRenderable   *mVertex4;
    PBRenderable   *mRenderable;
    
    PBTextureInfo  *mExpTextureInfo;
    
    NSMutableArray *mUsingExplosions;
    NSMutableArray *mSurplusExplosions;
    
    NSInteger       mTextureIndex;
}


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    
    if (self)
    {
        CGFloat sScale = [[UIScreen mainScreen] scale];

        mExpTextureInfo = [[PBTextureInfo alloc] initWithImageName:@"exp1"];
        [mExpTextureInfo load];
        
        mTextureIndex = 0;
        PBTileTexture *sExpTexture = [[PBTileTexture alloc] initWithTextureInfo:mExpTextureInfo];
        [sExpTexture setSize:CGSizeMake(64, 64)];
        mBoom = [[PBRenderable textureRenderableWithTexture:sExpTexture] retain];
        
        IndexTexture *sIndexTexture = [[[IndexTexture alloc] initWithImageSize:CGSizeMake(100, 50) scale:sScale] autorelease];
        mIndexLabel = [[PBRenderable textureRenderableWithTexture:sIndexTexture] retain];
        
        PBTexture *sTexture;
        
        sTexture = [[PBTexture textureWithImageName:@"poket0000.png"] load];
        mVertex1 = [[PBRenderable textureRenderableWithTexture:sTexture] retain];
        sTexture = [[PBTexture textureWithImageName:@"poket0001.png"] load];
        mVertex2 = [[PBRenderable textureRenderableWithTexture:sTexture] retain];
        sTexture = [[PBTexture textureWithImageName:@"poket0002.png"] load];
        mVertex3 = [[PBRenderable textureRenderableWithTexture:sTexture] retain];
        sTexture = [[PBTexture textureWithImageName:@"poket0003.png"] load];
        mVertex4 = [[PBRenderable textureRenderableWithTexture:sTexture] retain];

        PBTexture *sScaledTexture = [[[PBTexture alloc] initWithImageName:@"airship"] autorelease];
        [sScaledTexture load];
        mRenderable = [[PBRenderable textureRenderableWithTexture:sScaledTexture] retain];
        
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
    
    [mRenderable release];
    
    [mExpTextureInfo release];
    
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
    [mView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [mView registGestureEvent];
    
    [[mView renderable] addSubrenderable:mBoom];
    [[mView renderable] addSubrenderable:mIndexLabel];
    
    [[mView renderable] addSubrenderable:mVertex1];
    [[mView renderable] addSubrenderable:mVertex2];
    [[mView renderable] addSubrenderable:mVertex3];
    [[mView renderable] addSubrenderable:mVertex4];
    
    [[mView renderable] addSubrenderable:mRenderable];
    
    [[self view] addSubview:mView];
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
    [mIndexLabel setPosition:CGPointMake(sBounds.size.width / 2, sBounds.size.height / 2 - 80 * sScale)];
    
    [mRenderable setPosition:CGPointMake(sBounds.size.width / 2, 350 * sScale)];

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
    PBVertex3 sAngle;
    
    sAngle = [[mVertex1 transform] angle];
    sAngle.z += 3;
    [[mVertex1 transform] setAngle:sAngle];
    [[mVertex2 transform] setAngle:sAngle];
    [[mVertex3 transform] setAngle:sAngle];
    [[mVertex4 transform] setAngle:sAngle];
    
    
    if (mTextureIndex > 0)
    {
        [mBoom setHidden:NO];
        PBTileTexture *sTexture = (PBTileTexture *)[mBoom texture];
        [sTexture selectTileAtIndex:mTextureIndex];
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

    
    [(IndexTexture *)[mIndexLabel texture] setString:[NSString stringWithFormat:@"INDEX = %d : %2.1f FPS", mTextureIndex, 1.0 / aTimeInterval]];
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
        sExplosion = [[Explosion alloc] initWithTextureInfo:mExpTextureInfo];
    }
    
    [mUsingExplosions addObject:sExplosion];
    [[mView renderable] addSubrenderable:sExplosion];

    [sExplosion setPosition:sPoint];
    [sExplosion release];
}


@end
