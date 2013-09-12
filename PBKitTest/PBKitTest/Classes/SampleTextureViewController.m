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

        [mScaleXSlide setMinimumValue:0.0f];
        [mScaleXSlide setMaximumValue:1.0f];
        [mScaleXSlide setValue:kDefaultScale];
        
        [mScaleYSlide setMinimumValue:0.0f];
        [mScaleYSlide setMaximumValue:1.0f];
        [mScaleYSlide setValue:kDefaultScale];
                
        [mAngleSlide setMinimumValue:0];
        [mAngleSlide setMaximumValue:360];
        [mAngleSlide setValue:kDefaultAngle];
        
        [mAlphaSlide setMinimumValue:0.0f];
        [mAlphaSlide setMaximumValue:1.0f];
        [mAlphaSlide setValue:kDefaultAlpha];
        
        [self selectedTextureType:kTextureType];
        
        [mTextureView setScaleX:kDefaultScale];
        [mTextureView setScaleY:kDefaultScale];
        [mSpriteView setScaleX:kDefaultScale];
        [mSpriteView setScaleY:kDefaultScale];
        
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


- (IBAction)scaleXChanged:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    [mTextureView setScaleX:[sSlider value]];
    [mSpriteView setScaleX:[sSlider value]];
}


- (IBAction)scaleYChanged:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    [mTextureView setScaleY:[sSlider value]];
    [mSpriteView setScaleY:[sSlider value]];
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
