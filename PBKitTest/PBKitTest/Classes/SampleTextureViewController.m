/*
 *  SampleTextureViewController.m
 *  PBKitTest
 *
 *  Created by sshanks on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#import "SampleTextureViewController.h"
#import "SampleTextureView.h"
#import "PVRTextureView.h"
#import "SampleSpriteView.h"


typedef enum
{
    kTextureType = 0,
    kPVRTextureType,
    kSpriteType
} TextureType;


@implementation SampleTextureViewController


#pragma mark -


- (void)selectedTextureType:(TextureType)aType
{
    [mTextureView setHidden:YES];
    [mPVRTextureView setHidden:YES];
    [mSpriteView setHidden:YES];
    
    [mTextureView stopDisplayLoop];
    [mPVRTextureView stopDisplayLoop];
    [mSpriteView stopDisplayLoop];

    PBView *sSelectedView = nil;
    
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
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        CGRect sBound = [[UIScreen mainScreen] bounds];
        
        // TextureView
        mTextureView = [[[SampleTextureView alloc] initWithFrame:CGRectMake(0, 0, sBound.size.width, 260)] autorelease];
        [[self view] addSubview:mTextureView];
        [mTextureView setScale:1.0f];
        [mTextureView setVerticeX:-1.0f];
        [mTextureView setVerticeY:1.0f];
        
        mPVRTextureView = [[[PVRTextureView alloc] initWithFrame:CGRectMake(0, 0, sBound.size.width, 260)] autorelease];
        [[self view] addSubview:mPVRTextureView];
        [mPVRTextureView setScale:1.0f];
        [mPVRTextureView setVerticeX:-1.0f];
        [mPVRTextureView setVerticeY:1.0f];
        
        // SpriteView
        mSpriteView   = [[[SampleSpriteView alloc] initWithFrame:CGRectMake(0, 0, sBound.size.width, 260)] autorelease];
        [[self view] addSubview:mSpriteView];
        [mSpriteView setScale:1.0f];
        [mSpriteView setVerticeX:-1.0f];
        [mSpriteView setVerticeY:1.0f];
        
        // Common
        [mScaleSlide setMinimumValue:0.1f];
        [mScaleSlide setMaximumValue:1.0f];
        [mScaleSlide setValue:1.0f];
        
        [mVerticeFlipXSlide setMinimumValue:-1.0f];
        [mVerticeFlipXSlide setMaximumValue:1.0f];
        [mVerticeFlipXSlide setValue:-1.0f];
        
        [mVerticeFlipYSlide setMinimumValue:-1.0f];
        [mVerticeFlipYSlide setMaximumValue:1.0f];
        [mVerticeFlipYSlide setValue:1.0f];
        
        [mAngleSlide setMinimumValue:0];
        [mAngleSlide setMaximumValue:360];
        [mAngleSlide setValue:0];
        
        [self selectedTextureType:kTextureType];
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
}


#pragma mark -


- (IBAction)scaleChanged:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    [mTextureView setScale:[sSlider value]];
    [mPVRTextureView setScale:[sSlider value]];
    [mSpriteView setScale:[sSlider value]];
}


- (IBAction)verticeFlipXChanged:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    [mTextureView setVerticeX:[sSlider value]];
    [mPVRTextureView setVerticeX:[sSlider value]];
    [mSpriteView setVerticeX:[sSlider value]];
}


- (IBAction)verticeFlipYChanged:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    [mTextureView setVerticeY:[sSlider value]];
    [mPVRTextureView setVerticeY:[sSlider value]];
    [mSpriteView setVerticeY:[sSlider value]];
}


- (IBAction)angleChanged:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    NSLog(@"%f", [sSlider value]);
    [mTextureView setAngle:[sSlider value]];
    [mPVRTextureView setAngle:[sSlider value]];
    [mSpriteView setAngle:[sSlider value]];
}


- (IBAction)textureTypeSelected:(id)aSender
{
    UISegmentedControl *sSegment = (UISegmentedControl *)aSender;
    [self selectedTextureType:(TextureType)[sSegment selectedSegmentIndex]];
}


@end
