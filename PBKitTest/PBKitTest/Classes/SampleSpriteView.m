/*
 *  SampleSpriteView.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SampleSpriteView.h"


#define kSpriteImageCount 4


@implementation SampleSpriteView
{
    NSMutableArray      *mRenderables;
    NSUInteger           mSpriteIndex;
    CGFloat              mScale;
    CGFloat              mAngle;

    PBTextureInfoLoader *mTextureInfoLoader;
}


@synthesize scale = mScale;
@synthesize angle = mAngle;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
        
        mRenderables       = [[NSMutableArray alloc] init];
        mSpriteIndex       = 1;
        mTextureInfoLoader = [[PBTextureInfoLoader alloc] init];
        
        for (NSInteger i = 0; i < kSpriteImageCount; i++)
        {
            NSString  *sFilename = [NSString stringWithFormat:@"tornado%d.png", i + 1];
            PBTexture *sTexture  = [[[PBTexture alloc] initWithImageName:sFilename] autorelease];

            [mTextureInfoLoader addTextureInfo:[sTexture textureInfo]];
            
            PBRenderable *sRenderable = [[[PBRenderable alloc] init] autorelease];
            [sRenderable setProgram:[[PBProgramManager sharedManager] textureProgram]];
            [sRenderable setTexture:sTexture];
            
            [mRenderables addObject:sRenderable];
        }
        
        [mTextureInfoLoader load];
    }
    return self;
}


- (void)dealloc
{
    [mRenderables release];
    [mTextureInfoLoader release];
    
    [super dealloc];
}


#pragma mark -


- (void)pbViewUpdate:(PBView *)aView timeInterval:(CFTimeInterval)aTimeInterval displayLink:(CADisplayLink *)aDisplayLink
{
    PBRenderable *sRenderable = [mRenderables objectAtIndex:mSpriteIndex - 1];
    
    [[sRenderable transform] setScale:mScale];
    [[sRenderable transform] setAngle:PBVertex3Make(0, 0, mAngle)];
    [sRenderable setPosition:CGPointMake(0, 0)];
    
    [[self renderable] setSubrenderables:[NSArray arrayWithObjects:sRenderable, nil]];
    
    mSpriteIndex++;
    if (mSpriteIndex >= kSpriteImageCount)
    {
        mSpriteIndex = 1;
    }
}


@end
