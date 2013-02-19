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
    TextureLoadView     *mTextureLoadView;
    UIButton            *mButton;
    UIProgressView      *mProgressView;
    
    PBTextureInfoLoader *mTextureLoader;
}


@synthesize textureLoadView = mTextureLoadView;
@synthesize button          = mButton;
@synthesize progressView    = mProgressView;


#pragma mark -


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];

    if (self)
    {

    }
    
    return self;
}


- (void)dealloc
{
    [mTextureLoader release];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [mTextureLoadView setBackgroundColor:[PBColor blackColor]];
    
    Fighter *sFighter = [[[Fighter alloc] init] autorelease];
    [[mTextureLoadView renderable] setSubrenderables:[NSArray arrayWithObjects:sFighter, nil]];
    
    [mButton setTitle:@"Start" forState:UIControlStateNormal];
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
    
    [mTextureLoader cancel];
    [mTextureLoadView stopDisplayLoop];
}


#pragma mark -


- (IBAction)startButtonTapped:(id)aSender
{
    if (mTextureLoader)
    {
        [mTextureLoader setSuspended:([mTextureLoader isSuspended]) ? NO : YES];
    }
    else
    {
        mTextureLoader = [[PBTextureInfoLoader alloc] init];
        [mTextureLoader setDelegate:self];
        
        PBTextureInfo *sFailTextureInfo = [[PBTextureInfo alloc] initWithImageName:@"dddd"];
        [mTextureLoader addTextureInfo:sFailTextureInfo];
        [sFailTextureInfo release];
        
        for (NSInteger x = 0; x <= 24; x++)
        {
            for (NSInteger y = 0; y <= 19; y++)
            {
                PBTextureInfo *sTextureInfo = [[PBTextureInfo alloc] initWithImageName:[NSString stringWithFormat:@"poket%02d%02d", x, y]];
                [mTextureLoader addTextureInfo:sTextureInfo];
                [sTextureInfo release];
            }
        }
        
        [mTextureLoader load];
        
        [mProgressView setProgress:0];
    }
    
    [mButton setTitle:([mTextureLoader isSuspended] ? @"Start" : @"Stop") forState:UIControlStateNormal];
}


#pragma mark -


- (void)textureInfoLoaderWillStartLoad:(PBTextureInfoLoader *)aLoader
{

}


- (void)textureInfoLoaderDidFinishLoad:(PBTextureInfoLoader *)aLoader
{
    [mTextureLoader release];
    mTextureLoader = nil;
    
    [mButton setTitle:@"Start" forState:UIControlStateNormal];
}


- (void)textureInfoLoaderDidCancelLoad:(PBTextureInfoLoader *)aLoader
{
    NSLog(@"texture load did cancel");
}


- (void)textureInfoLoader:(PBTextureInfoLoader *)aLoader progress:(CGFloat)aProgress
{
    NSLog(@"progress = %f", aProgress);
    [mProgressView setProgress:aProgress];
}


- (void)textureInfoLoader:(PBTextureInfoLoader *)aLoader didFinishLoadTextureInfo:(PBTextureInfo *)aTextureInfo
{
    PBSprite *sSprite = [[[PBSprite alloc] initWithTextureInfo:aTextureInfo] autorelease];
    [[mTextureLoadView renderable] setSubrenderables:[NSArray arrayWithObject:sSprite]];
}


- (void)textureInfoLoader:(PBTextureInfoLoader *)aLoader didFailLoadTextureInfo:(PBTextureInfo *)aTextureInfo
{
    NSLog(@"fail = %@", aTextureInfo);
}


@end
