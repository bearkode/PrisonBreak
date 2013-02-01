/*
 *  SampleTextureView.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SampleTextureView.h"
#import <PBKit.h>


@implementation SampleTextureView
{

}


@synthesize scale    = mScale;
@synthesize angle    = mAngle;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        mShader  = [[PBShaderManager sharedManager] textureShader];
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];

        PBTexture *sTexture = [[[PBTexture alloc] initWithImageName:@"brown.png"] autorelease];
        [sTexture load];
        mTexture = [[PBRenderable alloc] initWithTexture:sTexture];
        [mTexture setProgramObject:[mShader programObject]];

        PBTexture *sTexture2 = [[[PBTexture alloc] initWithImageName:@"coin.png"] autorelease];
        [sTexture2 load];
        mTexture2 = [[PBRenderable alloc] initWithTexture:sTexture2];
        [mTexture2 setProgramObject:[mShader programObject]];
        
        PBTexture *sTexture3 = [[[PBTexture alloc] initWithImageName:@"balloon.png"] autorelease];
        [sTexture3 load];
        mTexture3 = [[PBRenderable alloc] initWithTexture:sTexture3];
        [mTexture3 setProgramObject:[mShader programObject]];
    }
    return self;
}


- (void)dealloc
{
    [mTexture release];
    [mTexture2 release];
    
    [super dealloc];
}


#pragma mark -


- (void)pbViewUpdate:(PBView *)aView timeInterval:(CFTimeInterval)aTimeInterval displayLink:(CADisplayLink *)aDisplayLink
{
    [[mTexture transform] setScale:mScale];
    [[mTexture transform] setAngle:PBVertex3Make(mAngle, 0, 0)];
    [mTexture  setPosition:CGPointMake(-70, 0)];
    
//    [[mTexture2 transform] setScale:mScale];
    [[mTexture2 transform] setAngle:PBVertex3Make(0, 0, mAngle)];
    [mTexture2 setPosition:CGPointMake(50, 50)];
    
    [[mTexture3 transform] setScale:mScale];
    [[mTexture3 transform] setAngle:PBVertex3Make(0, 0, mAngle)];
    [mTexture3 setPosition:CGPointMake(80, -20)];
    
    [mTexture setSubrenderables:[NSArray arrayWithObjects:mTexture2, nil]];
    [[self renderable] setSubrenderables:[NSArray arrayWithObjects:mTexture, mTexture3,  nil]];
}


@end
