/*
 *  SampleSpriteView.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SampleSpriteView.h"
#import "ProfilingOverlay.h"


#define kSpriteImageCount 4


@implementation SampleSpriteView
{
    NSMutableArray      *mLayers;
    NSUInteger           mSpriteIndex;
    CGFloat              mScale;
    CGFloat              mAngle;

    PBTextureLoader *mTextureInfoLoader;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setDelegate:self];
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
        
        mLayers            = [[NSMutableArray alloc] init];
        mSpriteIndex       = 1;
        mTextureInfoLoader = [[PBTextureLoader alloc] init];
        
        for (NSInteger i = 0; i < kSpriteImageCount; i++)
        {
            NSString  *sFilename = [NSString stringWithFormat:@"tornado%d.png", i + 1];
            PBTexture *sTexture  = [[[PBTexture alloc] initWithImageName:sFilename] autorelease];

            [mTextureInfoLoader addTexture:sTexture];
            
            PBLayer *sLayer = [[[PBLayer alloc] init] autorelease];
            [sLayer setProgram:[[PBProgramManager sharedManager] program]];
            [sLayer setName:sFilename];
            [sLayer setTexture:sTexture];
            [mLayers addObject:sLayer];
        }
        
        [mTextureInfoLoader load];
    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    
    [mLayers release];
    [mTextureInfoLoader release];
    
    [super dealloc];
}


#pragma mark -


- (void)pbCanvasUpdate:(PBCanvas *)aView
{
    [[ProfilingOverlay sharedManager] displayFPS:[aView fps] timeInterval:[aView timeInterval]];
    
    PBLayer *sLayer = [mLayers objectAtIndex:mSpriteIndex - 1];
    
    [[sLayer transform] setScale:[self scale]];
    [[sLayer transform] setAngle:PBVertex3Make(0, 0, [self angle])];
    [[sLayer transform] setAlpha:[self alpha]];
    [sLayer setPosition:CGPointMake(0, 0)];
    
    [[self rootLayer] setSublayers:[NSArray arrayWithObjects:sLayer, nil]];
    
    mSpriteIndex++;
    if (mSpriteIndex >= kSpriteImageCount)
    {
        mSpriteIndex = 1;
    }
}


@end
