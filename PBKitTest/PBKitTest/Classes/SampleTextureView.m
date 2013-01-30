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
        PBTexture *sTexture = [[[PBTexture alloc] initWithImageName:@"brown.png"] autorelease];
        [sTexture load];
       
        mRenderable = [[PBRenderable alloc] initWithTexture:sTexture];
        
        mShader  = [[PBShaderManager sharedManager] textureShader];
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
        [mRenderable setProgramObject:[mShader programObject]];
    }
    return self;
}


- (void)dealloc
{
    [mRenderable release];
    
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
