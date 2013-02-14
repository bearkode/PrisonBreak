/*
 *  TextureLoaderViewController.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 1. 30..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "TextureLoaderViewController.h"
#import <PBKit.h>
#import "TextureLoadView.h"
#import "Fighter.h"


@implementation TextureLoaderViewController
{
    TextureLoadView *mTextureLoadView;
    UIProgressView  *mProgressView;
    
    PBTextureLoader *mTextureLoader;
    NSMutableArray  *mTextureArray;
}


@synthesize textureLoadView = mTextureLoadView;
@synthesize progressView    = mProgressView;


#pragma mark -


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];

    if (self)
    {
        mTextureLoader = [[PBTextureLoader alloc] init];
        mTextureArray  = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mTextureLoader release];
    [mTextureArray release];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [mTextureLoadView setBackgroundColor:[PBColor blackColor]];
    
    Fighter *sFighter = [[[Fighter alloc] init] autorelease];
    [[mTextureLoadView renderable] setSubrenderables:[NSArray arrayWithObjects:sFighter, nil]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    mTextureLoadView = nil;
    mProgressView = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];
    
    [mTextureLoadView startDisplayLoop];
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
    
    [mTextureLoadView stopDisplayLoop];
}


#pragma mark -


- (IBAction)startButtonTapped:(id)aSender
{
    [mTextureLoader autorelease];
    mTextureLoader = [[PBTextureLoader alloc] init];
    [mTextureLoader setDelegate:self];
    
    [mTextureArray removeAllObjects];
    
    for (NSInteger x = 0; x <= 24; x++)
    {
        for (NSInteger y = 0; y <= 19; y++)
        {
            NSString *sName             = [NSString stringWithFormat:@"poket%02d%02d", x, y];
            PBTexture *sPoketMonTexture = [[[PBTexture alloc] initWithImageName:sName] autorelease];
            
            [mTextureLoader addTexture:sPoketMonTexture];
            [mTextureArray addObject:sPoketMonTexture];
        }
    }
    
    [mTextureLoader load];
    
    [mProgressView setProgress:0];
}


#pragma mark -


- (void)textureLoaderWillStartLoad:(PBTextureLoader *)aLoader
{

}


- (void)textureLoaderDidFinishLoad:(PBTextureLoader *)aLoader
{
    [mTextureLoader release];
    mTextureLoader = nil;
}


- (void)textureLoader:(PBTextureLoader *)aLoader progress:(CGFloat)aProgress
{
    [mProgressView setProgress:aProgress];
}


- (void)textureLoader:(PBTextureLoader *)aLoader didFinishLoadTexture:(PBTexture *)aTexture
{
    PBRenderable *sRenderable = [PBRenderable textureRenderableWithTexture:aTexture];
    [[mTextureLoadView renderable] setSubrenderables:[NSArray arrayWithObject:sRenderable]];
}


@end
