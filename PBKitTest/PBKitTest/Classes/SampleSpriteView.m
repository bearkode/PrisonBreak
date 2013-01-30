/*
 *  SampleSpriteView.m
 *  PBKitTest
 *
 *  Created by sshanks on 13. 1. 21..
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
@synthesize verticeX = mVerticeX;
@synthesize verticeY = mVerticeY;
@synthesize angle    = mAngle;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        mTextures      = [[NSMutableArray alloc] init];
        mSpriteIndex   = 1;
        mShader        = [[PBShaderManager sharedManager] textureShader];
        mTextureLoader = [[PBTextureLoader alloc] init];
        
        for (NSInteger i = 0; i < kSpriteImageCount; i++)
        {
            PBRenderable *sRenderable = [[[PBRenderable alloc] init] autorelease];
            NSString     *sFilename   = [NSString stringWithFormat:@"tornado%d.png", i + 1];
            PBTexture    *sTexture    = [[[PBTexture alloc] initWithImageName:sFilename] autorelease];
            
            [mTextureLoader addTexture:sTexture];
            
            [sRenderable setTexture:sTexture];
            [mTextures addObject:sRenderable];
        }
        
        [mTextureLoader load];
        
        mShader = [[PBShaderManager sharedManager] textureShader];
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
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


- (void)rendering
{
    PBRenderable *sRenderable = [mTextures objectAtIndex:mSpriteIndex - 1];
    
    [sRenderable setScale:mScale];
    PBVertice4 sVertices;
    CGFloat sVerticeX1 = mVerticeX;
    CGFloat sVerticeX2 = sVerticeX1 * -1;
    CGFloat sVerticeY1 = mVerticeY;
    CGFloat sVerticeY2 = sVerticeY1 * -1;
    
    sVertices = PBVertice4Make(sVerticeX1, sVerticeY1, sVerticeX2, sVerticeY2);
    [sRenderable setVertices:sVertices];
    [sRenderable setProgramObject:[mShader programObject]];
    
    PBTransform *sTransform = [sRenderable transform];
    [sTransform setAngle:mAngle];
    
    [self setSuperRenderable:sRenderable];
    
    mSpriteIndex++;
    if (mSpriteIndex >= kSpriteImageCount)
    {
        mSpriteIndex = 1;
    }
}


@end
