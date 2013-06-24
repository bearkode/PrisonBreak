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
    NSMutableArray  *mNodes;
    NSUInteger       mSpriteIndex;
    CGFloat          mScale;
    CGFloat          mAngle;
    PBTextureLoader *mTextureInfoLoader;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setDelegate:self];
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
        
        mNodes             = [[NSMutableArray alloc] init];
        mSpriteIndex       = 1;
        mTextureInfoLoader = [[PBTextureLoader alloc] init];
        
        for (NSInteger i = 0; i < kSpriteImageCount; i++)
        {
            NSString  *sFilename = [NSString stringWithFormat:@"tornado%d.png", i + 1];
            PBTexture *sTexture  = [[[PBTexture alloc] initWithImageName:sFilename] autorelease];

            [mTextureInfoLoader addTexture:sTexture];
            
            PBNode *sNode = [[[PBNode alloc] init] autorelease];
            [sNode setName:sFilename];
            [sNode setTexture:sTexture];
            [mNodes addObject:sNode];
        }
        
        [mTextureInfoLoader load];
    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    
    [mNodes release];
    [mTextureInfoLoader release];
    
    [super dealloc];
}


#pragma mark -


- (void)pbCanvasWillUpdate:(PBCanvas *)aView
{
    [[ProfilingOverlay sharedManager] displayFPS:[aView fps] timeInterval:[aView timeInterval]];
    
    PBNode *sNode = [mNodes objectAtIndex:mSpriteIndex - 1];
    
    [[sNode transform] setScale:[self scale]];
    [[sNode transform] setAngle:PBVertex3Make(0, 0, [self angle])];
    [[sNode transform] setAlpha:[self alpha]];
    [sNode setPoint:CGPointMake(0, 0)];
    
    [[sNode transform] setGrayscale:mGrayScale];
    [[sNode transform] setSepia:mSepia];
    [[sNode transform] setBlur:mBlur];
    [[sNode transform] setLuminance:mLuminance];
    
    [[self rootNode] setSubNodes:[NSArray arrayWithObjects:sNode, nil]];
    
    mSpriteIndex++;
    if (mSpriteIndex >= kSpriteImageCount)
    {
        mSpriteIndex = 1;
    }
}


@end
