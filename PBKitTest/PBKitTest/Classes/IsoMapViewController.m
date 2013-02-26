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


@implementation IsoMapViewController
{
    UIScrollView *mScrollView;
    
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
    [mMap release];
    [mOrigin release];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
    PBCanvas *sCanvas = [self canvas];
    
    [sCanvas setBackgroundColor:[PBColor grayColor]];
    [[sCanvas renderable] addSubrenderable:mMap];
    [[sCanvas renderable] addSubrenderable:mOrigin];

    CGRect sBounds   = [[self view] bounds];
    CGRect sMapBouns = [mMap bounds];
    
    mScrollView = [[UIScrollView alloc] initWithFrame:sBounds];
    [mScrollView setDelegate:self];
    [mScrollView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [mScrollView setContentSize:sMapBouns.size];
    [[self view] addSubview:mScrollView];
    [mScrollView release];
}


- (void)viewDidUnload
{
    [self viewDidUnload];
    
    mScrollView = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    mScrollView = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];
    
    CGRect sBounds    = [[self view] bounds];
    CGRect sMapBounds = [mMap bounds];
    
    [mScrollView setContentOffset:CGPointMake(sMapBounds.size.width / 2 - sBounds.size.width / 2, sMapBounds.size.height / 2 - sBounds.size.height / 2)];
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGPoint sOffset    = [aScrollView contentOffset];
    CGRect  sBounds    = [[self view] bounds];
    CGRect  sMapBounds = [mMap bounds];
    CGPoint sCameraPos = CGPointZero;
    
    sCameraPos.x = sOffset.x - sMapBounds.size.width / 2 + sBounds.size.width / 2;
    sCameraPos.y = -sOffset.y - sBounds.size.height / 2;
    
    [[[self canvas] camera] setPosition:sCameraPos];
}


@end
