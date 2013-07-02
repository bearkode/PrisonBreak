/*
 *  SampleTextureViewController.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SampleTextureViewController.h"
#import "SampleTextureView.h"
#import "SampleSpriteView.h"


@implementation SampleTextureViewController
{
    TextureView *mCurrentView;
}

#pragma mark -


- (void)selectedTextureType:(TextureType)aType
{
    [mTextureView setHidden:YES];
    [mSpriteView setHidden:YES];
    
    [mTextureView stopDisplayLoop];
    [mSpriteView stopDisplayLoop];

    TextureView *sSelectedView = nil;
    
    switch (aType)
    {
        case kTextureType:
            sSelectedView = mTextureView;
            break;
        case kSpriteType:
            sSelectedView = mSpriteView;
            break;            
        default:
            break;
    }
    
    [sSelectedView setHidden:NO];
    [sSelectedView startDisplayLoop];
    
    mCurrentView = sSelectedView;
}


#pragma mark -


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        CGRect sBounds = [[UIScreen mainScreen] bounds];
        
        mTextureView = [[[SampleTextureView alloc] initWithFrame:CGRectMake(0, 0, sBounds.size.width, 200)] autorelease];
        [[self view] addSubview:mTextureView];
        
        mSpriteView   = [[[SampleSpriteView alloc] initWithFrame:CGRectMake(0, 0, sBounds.size.width, 200)] autorelease];
        [[self view] addSubview:mSpriteView];

        [mScaleSlide setMinimumValue:0.0f];
        [mScaleSlide setMaximumValue:1.0f];
        [mScaleSlide setValue:kDefaultScale];
                
        [mAngleSlide setMinimumValue:0];
        [mAngleSlide setMaximumValue:360];
        [mAngleSlide setValue:kDefaultAngle];
        
        [mAlphaSlide setMinimumValue:0.0f];
        [mAlphaSlide setMaximumValue:1.0f];
        [mAlphaSlide setValue:kDefaultAlpha];
        
        [self selectedTextureType:kTextureType];
        
        [mTextureView setScale:kDefaultScale];
        [mSpriteView setScale:kDefaultScale];
        
        [mTextureView setAngle:kDefaultAngle];
        [mSpriteView setAngle:kDefaultAngle];
        
        [mTextureView setAlpha:kDefaultAlpha];
        [mSpriteView setAlpha:kDefaultAlpha];
    }
    return self;
}


- (void)dealloc
{
    [PBTextureManager vacate];
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
    
    [mTextureView stopDisplayLoop];
    [mSpriteView  stopDisplayLoop];
}


#pragma mark -


- (IBAction)textureTypeSelected:(id)aSender
{
    UISegmentedControl *sSegment = (UISegmentedControl *)aSender;
    [self selectedTextureType:(TextureType)[sSegment selectedSegmentIndex]];
}


- (IBAction)scaleChanged:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    [mTextureView setScale:[sSlider value]];
    [mSpriteView setScale:[sSlider value]];
}


- (IBAction)angleChanged:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    [mTextureView setAngle:[sSlider value]];
    [mSpriteView setAngle:[sSlider value]];
}


- (IBAction)alphaChanged:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    [mTextureView setAlpha:[sSlider value]];
    [mSpriteView setAlpha:[sSlider value]];
}


@end
