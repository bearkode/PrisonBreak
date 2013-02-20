/*
 *  MapViewController.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 2. 19..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "MapViewController.h"
#import "Map.h"


@implementation MapViewController
{
    PBCanvas     *mView;
    UIScrollView *mScrollView;
    
    Map           *mMap;
    PBSprite      *mOrigin;
}


- (void)setupMap
{
    NSString *sPath       = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"json"];
    NSData   *sData       = [NSData dataWithContentsOfFile:sPath];
    id        sJsonObject = [NSJSONSerialization JSONObjectWithData:sData options:0 error:nil];
//    NSLog(@"sJsonObject = %@", sJsonObject);
    NSInteger sWidth      = [[sJsonObject objectForKey:@"width"] integerValue];
    NSInteger sHeight     = [[sJsonObject objectForKey:@"height"] integerValue];
    CGSize    sMapSize    = CGSizeMake(sWidth, sHeight);
    NSInteger sTileWidth  = [[sJsonObject objectForKey:@"tilewidth"] integerValue];
    NSInteger sTileHeight = [[sJsonObject objectForKey:@"tileheight"] integerValue];
    CGSize    sTileSize   = CGSizeMake(sTileWidth, sTileHeight);
    NSArray  *sTiles      = [[[sJsonObject objectForKey:@"layers"] objectAtIndex:0] objectForKey:@"data"];
    NSString *sImageName  = [[[sJsonObject objectForKey:@"tilesets"] objectAtIndex:0] objectForKey:@"image"];
    UIImage  *sImage      = [UIImage imageNamed:sImageName];
    
    mMap = [[Map alloc] initWithMapSize:sMapSize tileImage:sImage tileSize:sTileSize indexArray:sTiles];
}


#pragma mark -


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];

    if (self)
    {
        [self setupMap];
        
        mOrigin = [[PBSprite alloc] initWithImageName:@"poket0018"];
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
    
    CGRect sBounds = [[self view] bounds];
    
    mView = [[PBCanvas alloc] initWithFrame:sBounds];
    [mView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [mView setBackgroundColor:[PBColor grayColor]];
    [[mView renderable] setSubrenderables:[NSArray arrayWithObject:mMap]];
    [[self view] addSubview:mView];
    [mView release];

    CGRect sContentRect = [mMap bounds];
    
    mScrollView = [[UIScrollView alloc] initWithFrame:sBounds];
    [mScrollView setDelegate:self];
    [mScrollView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [mScrollView setContentSize:sContentRect.size];
    [[self view] addSubview:mScrollView];
    [mScrollView release];
    
    [[mView renderable] addSubrenderable:mOrigin];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    mView = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];
    
    CGRect sBounds = [[self view] bounds];
    
    [[mView camera] setPosition:CGPointMake(sBounds.size.width / 2, sBounds.size.height / 2)];
    [self scrollViewDidScroll:mScrollView];
    
    [mView startDisplayLoop];
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
    
    [mView stopDisplayLoop];
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGRect  sBounds      = [[self view] bounds];
    CGPoint sOffset      = [aScrollView contentOffset];
    CGRect  sMapBounds   = [mMap bounds];
//    CGPoint sMapPosition = CGPointMake(0 - sOffset.x, -sMapBounds.size.height + sBounds.size.height + sOffset.y);
    CGRect  sVisibleRect = CGRectMake(sOffset.x, sMapBounds.size.height - (sOffset.y + sBounds.size.height), sBounds.size.width, sBounds.size.height);
    
//    NSLog(@"sOffset = %@", NSStringFromCGPoint(sOffset));
//    NSLog(@"sVisibleRect = %@", NSStringFromCGRect(sVisibleRect));
    
//    [mMap setPosition:sMapPosition];
    [mMap setVisibleRect:sVisibleRect];
}


@end
