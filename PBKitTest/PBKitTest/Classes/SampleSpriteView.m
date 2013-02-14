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
    PBTextureLoader *mTextureLoader;
}


@synthesize scale    = mScale;
@synthesize angle    = mAngle;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        mShader = [[PBShaderManager sharedManager] textureShader];
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
        
        mTextures      = [[NSMutableArray alloc] init];
        mSpriteIndex   = 1;
        mShader        = [[PBShaderManager sharedManager] textureShader];
        mTextureLoader = [[PBTextureLoader alloc] init];
        
        for (NSInteger i = 0; i < kSpriteImageCount; i++)
        {
            PBRenderable *sRenderable = [[[PBRenderable alloc] init] autorelease];
            [sRenderable setProgram:[mShader program]];
            
            NSString     *sFilename   = [NSString stringWithFormat:@"tornado%d.png", i + 1];
            PBTexture    *sTexture    = [[[PBTexture alloc] initWithImageName:sFilename] autorelease];
            [mTextureLoader addTexture:sTexture];
            
            [sRenderable setTexture:sTexture];
            [mTextures addObject:sRenderable];
        }
        
        [mTextureLoader load];
    }
    return self;
}


- (void)dealloc
{
    [mTextures release];
    [mTextureLoader release];
    
    [super dealloc];
}


#pragma mark -


- (void)pbViewUpdate:(PBView *)aView timeInterval:(CFTimeInterval)aTimeInterval displayLink:(CADisplayLink *)aDisplayLink
{
    PBRenderable *sRenderable = [mTextures objectAtIndex:mSpriteIndex - 1];
    
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
