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
    
    PBTextureLoader     *mTextureLoader;
    PBScene             *mScene;
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
    [mScene release];
    [mTextureLoader release];
    
    [PBTextureManager vacate];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [mTextureLoadView setBackgroundColor:[PBColor blackColor]];
    Fighter *sFighter = [[[Fighter alloc] init] autorelease];
    
    mScene = [[PBScene alloc] initWithDelegate:self];
    [mTextureLoadView presentScene:mScene];

    [mScene setSubNodes:[NSArray arrayWithObjects:sFighter, nil]];

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
        mTextureLoader = [[PBTextureLoader alloc] init];
        [mTextureLoader setDelegate:self];
        
        PBTexture *sFailTexture = [[PBTexture alloc] initWithImageName:@"dddd"];
        [mTextureLoader addTexture:sFailTexture];
        [sFailTexture release];
        
        for (NSInteger x = 0; x <= 24; x++)
        {
            for (NSInteger y = 0; y <= 19; y++)
            {
                PBTexture *sTexture = [[PBTexture alloc] initWithImageName:[NSString stringWithFormat:@"poket%02d%02d", (int)x, (int)y]];
                [mTextureLoader addTexture:sTexture];
                [sTexture release];
            }
        }
        
        [mTextureLoader load];
        
        [mProgressView setProgress:0];
    }
    
    [mButton setTitle:([mTextureLoader isSuspended] ? @"Start" : @"Stop") forState:UIControlStateNormal];
}


#pragma mark -


- (void)textureLoaderWillStartLoad:(PBTextureLoader *)aLoader
{

}


- (void)textureLoaderDidFinishLoad:(PBTextureLoader *)aLoader
{
    [mTextureLoader release];
    mTextureLoader = nil;
    
    [mButton setTitle:@"Start" forState:UIControlStateNormal];
}


- (void)textureLoaderDidCancelLoad:(PBTextureLoader *)aLoader
{
//    NSLog(@"texture load did cancel");
}


- (void)textureLoader:(PBTextureLoader *)aLoader progress:(CGFloat)aProgress
{
//    NSLog(@"progress = %f", aProgress);
    [mProgressView setProgress:aProgress];
}


- (void)textureLoader:(PBTextureLoader *)aLoader didFinishLoadTexture:(PBTexture *)aTexture
{
//    NSLog(@"didFinishLoadTexture");
    
    PBSpriteNode *sNode = [PBSpriteNode spriteNodeWithTexture:aTexture];
    [mScene setSubNodes:[NSArray arrayWithObject:sNode]];
}


- (void)textureLoader:(PBTextureLoader *)aLoader didFailLoadTexture:(PBTexture *)aTexture
{
//    NSLog(@"fail = %@", aTexture);
}


@end
