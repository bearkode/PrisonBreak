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


@implementation IsoMapViewController
{
    UIScrollView *mScrollView;
    UIView       *mEmptyView;
    
    BOOL          mZooming;
    IsoMap       *mMap;
    PBSprite     *mOrigin;
}


#pragma mark -


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];

    if (self)
    {
        NSString *sPath = [[NSBundle mainBundle] pathForResource:@"isomap" ofType:@"json"];
        mMap = [[IsoMap alloc] initWithContentsOfFile:sPath];
        
        mOrigin = [[PBSprite alloc] initWithImageName:@"cross"];
    }
    
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    
    [mMap release];
    [mOrigin release];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSLog(@"viewDidLoad");
    
    PBCanvas *sCanvas = [self canvas];
    
    [sCanvas setBackgroundColor:[PBColor grayColor]];
    [sCanvas setDelegate:self];
    [[sCanvas rootLayer] addSublayer:mMap];
    [[sCanvas rootLayer] addSublayer:mOrigin];

    CGRect sBounds   = [[self view] bounds];
    CGRect sMapBouns = [mMap bounds];
    
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
//        NSLog(@"end");
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
//    NSLog(@"offset = %@", NSStringFromCGPoint([aScrollView contentOffset]));
    
//    if (!mZooming)
//    {
        [self updateCamera];
//    }
}


- (void)scrollViewDidZoom:(UIScrollView *)aScrollView
{
//    NSLog(@"zoom = %f", [aScrollView zoomScale]);
    [[[self canvas] camera] setZoomScale:[aScrollView zoomScale]];
}


- (void)pbCanvasUpdate:(PBCanvas *)aView
{
    [[ProfilingOverlay sharedManager] displayFPS:[aView fps] timeInterval:[aView timeInterval]];
}

@end
