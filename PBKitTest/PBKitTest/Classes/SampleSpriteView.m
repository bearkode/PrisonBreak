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
    PBScene         *mScene;
}


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self)
    {
        mScene = [[PBScene alloc] initWithDelegate:self];
        [self presentScene:mScene];
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
        
        mNodes             = [[NSMutableArray alloc] init];
        mSpriteIndex       = 1;
        mTextureInfoLoader = [[PBTextureLoader alloc] init];
        
        for (NSInteger i = 0; i < kSpriteImageCount; i++)
        {
            NSString  *sFilename = [NSString stringWithFormat:@"tornado%d.png", (int)(i + 1)];
            PBTexture *sTexture  = [[[PBTexture alloc] initWithImageName:sFilename] autorelease];

            [mTextureInfoLoader addTexture:sTexture];
            
            PBSpriteNode *sNode = [[[PBSpriteNode alloc] initWithTexture:sTexture] autorelease];
            [sNode setName:sFilename];
            [mNodes addObject:sNode];
        }
        
        [mTextureInfoLoader load];
    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    
    [mScene release];
    [mNodes release];
    [mTextureInfoLoader release];
    
    [super dealloc];
}


#pragma mark -


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
    [[ProfilingOverlay sharedManager] displayFPS:[self fps] timeInterval:[self timeInterval]];
    
    PBSpriteNode *sNode = [mNodes objectAtIndex:mSpriteIndex - 1];
    
    [sNode setScale:PBVertex3Make([self scaleX], [self scaleY], 1.0f)];
    [sNode setAngle:PBVertex3Make(0, 0, [self angle])];
    [sNode setAlpha:[self alpha]];
    [sNode setPoint:CGPointMake(0, 0)];

    [mScene setSubNodes:[NSArray arrayWithObjects:sNode, nil]];
    
    mSpriteIndex++;
    if (mSpriteIndex >= kSpriteImageCount)
    {
        mSpriteIndex = 1;
    }
}


@end
