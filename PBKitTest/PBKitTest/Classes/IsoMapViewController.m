/*
 *  IsoMapViewController.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 2. 21..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "IsoMapViewController.h"
#import "IsoMap.h"
#import "ProfilingOverlay.h"
#import "PBSpriteNode.h"
#import "PBSpriteNode+TileAddition.h"


@implementation IsoMapViewController
{
    UIScrollView *mScrollView;
    UIView       *mEmptyView;
    
    BOOL          mZooming;
    IsoMap       *mMap;
    PBSpriteNode *mOrigin;
    
    PBSpriteNode *mCurrentTile;
    NSInteger     mCurrentIndex;
}


#pragma mark -


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];

    if (self)
    {
        NSString *sPath = [[NSBundle mainBundle] pathForResource:@"isomap" ofType:@"json"];
        mMap = [[IsoMap alloc] initWithContentsOfFile:sPath];
        
        PBTexture *sTexture = [[[PBTexture alloc] initWithImageName:@"cross"] autorelease];
        [sTexture loadIfNeeded];
        
        mOrigin = [[PBSpriteNode alloc] initWithTexture:sTexture];
        
        mCurrentTile = [[PBSpriteNode alloc] initWithImageNamed:@"isoback_conv"];
        [mCurrentTile setTileSize:CGSizeMake(63, 32)];
        [mCurrentTile setPoint:CGPointMake(0, 0)];
    }
    
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    
    [mMap release];
    [mOrigin release];
    
    [mCurrentTile release];
    
    [PBTextureManager vacate];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect sBounds   = [[self view] bounds];
    CGRect sMapBouns = [mMap bounds];

    PBCanvas *sCanvas = [self canvas];
    [sCanvas setBackgroundColor:[PBColor grayColor]];
    
    PBScene *sScene = [[[PBScene alloc] initWithDelegate:self] autorelease];
    [sCanvas presentScene:sScene];

    [sScene addSubNode:mMap];
    [sScene addSubNode:mOrigin];
    
    mScrollView = [[UIScrollView alloc] initWithFrame:sBounds];
    [mScrollView setDelegate:self];
    [mScrollView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [mScrollView setContentSize:sMapBouns.size];
    [mScrollView setMinimumZoomScale:0.5];
    [mScrollView setMaximumZoomScale:2.0];
    [mScrollView setZoomScale:1.0];
    [[self view] addSubview:mScrollView];
    [mScrollView release];
    
    mEmptyView = [[UIView alloc] initWithFrame:sMapBouns];
    [mScrollView addSubview:mEmptyView];
    [mEmptyView release];

#if (0)
    UIButton *sPrevButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sPrevButton setTitle:@"Prev" forState:UIControlStateNormal];
    [sPrevButton setFrame:CGRectMake(10, 360, 50, 44)];
    [sPrevButton addTarget:self action:@selector(prevButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:sPrevButton];
    [[self view] bringSubviewToFront:sPrevButton];
    
    UIButton *sNextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sNextButton setTitle:@"Next" forState:UIControlStateNormal];
    [sNextButton setFrame:CGRectMake(10 + 100, 360, 50, 44)];
    [sNextButton addTarget:self action:@selector(nextButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:sNextButton];
    [[self view] bringSubviewToFront:sNextButton];
#endif
}


- (void)viewDidUnload
{
    [self viewDidUnload];
    
    mScrollView = nil;
    mEmptyView = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    mScrollView = nil;
    mEmptyView = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];
    
    CGRect sBounds    = [[self view] bounds];
    CGRect sMapBounds = [mMap bounds];
    
    [mScrollView setContentOffset:CGPointMake(sMapBounds.size.width / 2 - sBounds.size.width / 2, sMapBounds.size.height / 2 - sBounds.size.height / 2)];

    [[[self canvas] camera] setPosition:CGPointMake(100, 100)];
    [[[self canvas] camera] setZoomScale:0.5];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerExpired:) userInfo:nil repeats:YES];
}


- (void)timerExpired:(NSTimer *)aTimer
{
    PBCamera *sCamera    = [[self canvas] camera];
    CGFloat   sZoomScale = [sCamera zoomScale] + 0.1;
    
    if (sZoomScale > 2.0)
    {
        [aTimer invalidate];
        [sCamera setZoomScale:1.0];
    }
    else
    {
        [sCamera setZoomScale:sZoomScale];
    }
}


- (void)updateCamera
{
    CGPoint sOffset      = [mScrollView contentOffset];
    CGSize  sContentSize = [mScrollView contentSize];
    CGRect  sBounds      = [mScrollView bounds];
    CGRect  sMapBounds   = [mMap bounds];
    CGPoint sCameraPos   = CGPointZero;
    CGSize  sMax         = CGSizeMake(sContentSize.width - sBounds.size.width, sContentSize.height - sBounds.size.height);
    CGPoint sPercent     = CGPointMake(sOffset.x / sMax.width - 0.5, sOffset.y / sMax.height - 0.5);
    CGFloat sZoomScale   = [[[self canvas] camera] zoomScale];
    
    sCameraPos.x = sPercent.x * (sMapBounds.size.width - sBounds.size.width / sZoomScale);
    sCameraPos.y = -sPercent.y * (sMapBounds.size.height - sBounds.size.height / sZoomScale);

    [[[self canvas] camera] setPosition:sCameraPos];
}


#pragma mark -


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)aScrollView
{
    return mEmptyView;
}


- (void)scrollViewWillBeginZooming:(UIScrollView *)aScrollView withView:(UIView *)aView
{
    mZooming = YES;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)aScrollView withView:(UIView *)aView atScale:(float)aScale
{
    mZooming = NO;
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [self updateCamera];
}


- (void)scrollViewDidZoom:(UIScrollView *)aScrollView
{
    [[[self canvas] camera] setZoomScale:[aScrollView zoomScale]];
}


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
    [[ProfilingOverlay sharedManager] displayFPS:[[self canvas] fps] timeInterval:[[self canvas] timeInterval]];
}


#pragma mark -


#if (0)
- (IBAction)prevButtonTapped:(id)aSender
{
    mCurrentIndex--;
    
    if (mCurrentIndex < 0)
    {
        mCurrentIndex = 17;
    }
    
    NSLog(@"index = %d", mCurrentIndex);
    [mCurrentTile selectSpriteAtIndex:mCurrentIndex];
}


- (IBAction)nextButtonTapped:(id)aSender
{
    mCurrentIndex++;
    
    if (mCurrentIndex > 17)
    {
        mCurrentIndex = 0;
    }

    NSLog(@"index = %d", mCurrentIndex);    
    [mCurrentTile selectSpriteAtIndex:mCurrentIndex];
}
#endif


@end
