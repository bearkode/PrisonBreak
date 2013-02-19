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
#import "PVRTextureView.h"
#import "SampleSpriteView.h"


@implementation SampleTextureViewController
{
    TextureView *mCurrentView;
}

#pragma mark -


- (void)selectedTextureType:(TextureType)aType
{
    [mTextureView setHidden:YES];
    [mPVRTextureView setHidden:YES];
    [mSpriteView setHidden:YES];
    
    [mTextureView stopDisplayLoop];
    [mPVRTextureView stopDisplayLoop];
    [mSpriteView stopDisplayLoop];

    TextureView *sSelectedView = nil;
    
    switch (aType)
    {
        case kTextureType:
            sSelectedView = mTextureView;
            break;
        
        case kPVRTextureType:
            sSelectedView = mPVRTextureView;
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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        CGRect sBound = [[UIScreen mainScreen] bounds];
        
        mTextureView = [[[SampleTextureView alloc] initWithFrame:CGRectMake(0, 0, sBound.size.width, 200)] autorelease];
        [[self view] addSubview:mTextureView];
        
        mPVRTextureView = [[[PVRTextureView alloc] initWithFrame:CGRectMake(0, 0, sBound.size.width, 200)] autorelease];
        [[self view] addSubview:mPVRTextureView];
        
        mSpriteView   = [[[SampleSpriteView alloc] initWithFrame:CGRectMake(0, 0, sBound.size.width, 200)] autorelease];
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
        
        [mBlurSwitch setOn:NO];
        [mLuminanceSwitch setOn:NO];
        [mGrayScaleSwitch setOn:NO];
        [mSepiaSwitch setOn:NO];
        
        [self selectedTextureType:kTextureType];
        
        [mTextureView setScale:kDefaultScale];
        [mPVRTextureView setScale:kDefaultScale];
        [mSpriteView setScale:kDefaultScale];
        
        [mTextureView setAngle:kDefaultAngle];
        [mPVRTextureView setAngle:kDefaultAngle];
        [mSpriteView setAngle:kDefaultAngle];
        
        [mTextureView setAlpha:kDefaultAlpha];
        [mPVRTextureView setAlpha:kDefaultAlpha];
        [mSpriteView setAlpha:kDefaultAlpha];
    }
    return self;
}


- (void)dealloc
{
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
    [mPVRTextureView stopDisplayLoop];
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
    [mPVRTextureView setScale:[sSlider value]];
    [mSpriteView setScale:[sSlider value]];
}


- (IBAction)angleChanged:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    [mTextureView setAngle:[sSlider value]];
    [mPVRTextureView setAngle:[sSlider value]];
    [mSpriteView setAngle:[sSlider value]];
}


- (IBAction)alphaChanged:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    [mTextureView setAlpha:[sSlider value]];
    [mPVRTextureView setAlpha:[sSlider value]];
    [mSpriteView setAlpha:[sSlider value]];
}


- (IBAction)blurChanged:(id)aSender
{
    UISwitch *sSwitch = (UISwitch *)aSender;
    [mTextureView setBlur:[sSwitch isOn]];
    [mPVRTextureView setBlur:[sSwitch isOn]];
    [mSpriteView setBlur:[sSwitch isOn]];
}


- (IBAction)luminanceChanged:(id)aSender
{
    UISwitch *sSwitch = (UISwitch *)aSender;
    [mTextureView setLuminance:[sSwitch isOn]];
    [mPVRTextureView setLuminance:[sSwitch isOn]];
    [mSpriteView setLuminance:[sSwitch isOn]];
}


- (IBAction)grayScaleChanged:(id)aSender
{
    UISwitch *sSwitch = (UISwitch *)aSender;
    if ([sSwitch isOn])
    {
        [mSepiaSwitch setOn:NO];
        [mTextureView setSepia:NO];
        [mPVRTextureView setSepia:NO];
        [mSpriteView setSepia:NO];
    }
    [mTextureView setGrayScale:[sSwitch isOn]];
    [mPVRTextureView setGrayScale:[sSwitch isOn]];
    [mSpriteView setGrayScale:[sSwitch isOn]];
}


- (IBAction)sepiaChanged:(id)aSender
{
    UISwitch *sSwitch = (UISwitch *)aSender;
    if ([sSwitch isOn])
    {
        [mGrayScaleSwitch setOn:NO];
        [mTextureView setGrayScale:NO];
        [mPVRTextureView setGrayScale:NO];
        [mSpriteView setGrayScale:NO];
    }
    [mTextureView setSepia:[sSwitch isOn]];
    [mPVRTextureView setSepia:[sSwitch isOn]];
    [mSpriteView setSepia:[sSwitch isOn]];
}


@end
