/*
 *  SampleTextureView.m
 *  PBKitTest
 *
 *  Created by sshanks on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SampleTextureView.h"
#import <PBKit.h>


@implementation SampleTextureView
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
//        PBTexture *sTexture = [PBTextureLoader textureNamed:@"brown.png"];
//        NSLog(@"add texture load operation");
        
//        PBTextureLoadOperation *sOperation = [[[PBTextureLoadOperation alloc] initWithTextureName:@"brown.png"] autorelease];
//        [[PBTextureLoader sharedLoader] enqueueTextureLoadOperation:sOperation];
        
        PBTexture *sTexture = [[[PBTexture alloc] initWithImageName:@"brown.png"] autorelease];
        [sTexture load];
       
        mRenderable = [[PBRenderable alloc] initWithTexture:sTexture];
        
        mShader  = [[PBShaderManager sharedManager] textureShader];
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
        [mRenderable setProgramObject:[mShader programObject]];
        
        mTextureLoader = [[PBTextureLoader alloc] init];

        NSLog(@"begin");
        for (NSInteger x = 0; x <= 19; x++)
        {
            for (NSInteger y = 0; y <= 24; y++)
            {
                NSString *sName             = [NSString stringWithFormat:@"poket%02d%02d", x, y];
                PBTexture *sPoketMonTexture = [[[PBTexture alloc] initWithImageName:sName] autorelease];

                [mTextureLoader addTexture:sPoketMonTexture];
            }
        }
        NSLog(@"end");
    }
    return self;
}


- (void)dealloc
{
    [mRenderable release];
    [mTextureLoader release];
    
    [super dealloc];
}


#pragma mark -


- (void)rendering
{
    [mRenderable setScale:mScale];
    
    PBVertice4 sVertices;
    CGFloat sVerticeX1 = mVerticeX;
    CGFloat sVerticeX2 = sVerticeX1 * -1;
    CGFloat sVerticeY1 = mVerticeY;
    CGFloat sVerticeY2 = sVerticeY1 * -1;
    
    sVertices = PBVertice4Make(sVerticeX1, sVerticeY1, sVerticeX2, sVerticeY2);
    [mRenderable setVertices:sVertices];
//    [mRenderable setPosition:CGPointMake(100, 100)];
    
    PBTransform *sTransform = [mRenderable transform];
    [sTransform setAngle:mAngle];
    
    [self setSuperRenderable:mRenderable];
}


@end
