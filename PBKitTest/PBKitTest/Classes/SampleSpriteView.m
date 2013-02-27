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
    NSMutableArray      *mRenderables;
    NSUInteger           mSpriteIndex;
    CGFloat              mScale;
    CGFloat              mAngle;

    PBTextureInfoLoader *mTextureInfoLoader;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setDelegate:self];
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
        
        mRenderables       = [[NSMutableArray alloc] init];
        mSpriteIndex       = 1;
        mTextureInfoLoader = [[PBTextureInfoLoader alloc] init];
        
        for (NSInteger i = 0; i < kSpriteImageCount; i++)
        {
            NSString  *sFilename = [NSString stringWithFormat:@"tornado%d.png", i + 1];
            PBTexture *sTexture  = [[[PBTexture alloc] initWithImageName:sFilename] autorelease];

            [mTextureInfoLoader addTextureInfo:[sTexture textureInfo]];
            
            PBLayer *sRenderable = [[[PBLayer alloc] init] autorelease];
            [sRenderable setTexture:sTexture];            
            [mRenderables addObject:sRenderable];
        }
        
        [mTextureInfoLoader load];
    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    
    [mRenderables release];
    [mTextureInfoLoader release];
    
    [super dealloc];
}


#pragma mark -


- (void)pbCanvasUpdate:(PBCanvas *)aView
{
    [[ProfilingOverlay sharedManager] displayFPS:[aView fps] timeInterval:[aView timeInterval]];
    
    PBLayer *sRenderable = [mRenderables objectAtIndex:mSpriteIndex - 1];
    
    [[sRenderable transform] setScale:[self scale]];
    [[sRenderable transform] setAngle:PBVertex3Make(0, 0, [self angle])];
    [[sRenderable transform] setAlpha:[self alpha]];
    [sRenderable setPosition:CGPointMake(0, 0)];
    
    [[self renderable] setSubrenderables:[NSArray arrayWithObjects:sRenderable, nil]];
    
    mSpriteIndex++;
    if (mSpriteIndex >= kSpriteImageCount)
    {
        mSpriteIndex = 1;
    }
}


@end
