/*
 *  SampleTextureView.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 21..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "SampleTextureView.h"
#import <PBKit.h>


@implementation SampleTextureView
{

}


@synthesize scale = mScale;
@synthesize angle = mAngle;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        mShader  = [[PBShaderManager sharedManager] textureShader];
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];

        PBTexture *sTexture = [[[PBTexture alloc] initWithImageName:@"brown.png"] autorelease];
        [sTexture load];
        mRenderable1 = [[PBRenderable alloc] initWithTexture:sTexture];
        [mRenderable1 setProgramObject:[mShader programObject]];

        PBTexture *sTexture2 = [[[PBTexture alloc] initWithImageName:@"coin.png"] autorelease];
        [sTexture2 load];
        mRenderable2 = [[PBRenderable alloc] initWithTexture:sTexture2];
        [mRenderable2 setProgramObject:[mShader programObject]];
        
        PBTexture *sTexture3 = [[[PBTexture alloc] initWithImageName:@"balloon.png"] autorelease];
        [sTexture3 load];
        mRenderable3 = [[PBRenderable alloc] initWithTexture:sTexture3];
        [mRenderable3 setProgramObject:[mShader programObject]];
    }
    return self;
}


- (void)dealloc
{
    [mRenderable1 release];
    [mRenderable2 release];
    [mRenderable3 release];
    
    [super dealloc];
}


#pragma mark -


- (void)pbViewUpdate:(PBView *)aView timeInterval:(CFTimeInterval)aTimeInterval displayLink:(CADisplayLink *)aDisplayLink
{
    [[mRenderable1 transform] setScale:mScale];
    [[mRenderable1 transform] setAngle:PBVertex3Make(mAngle, 0, 0)];
    [mRenderable1  setPosition:CGPointMake(-70, 0)];
    
//    [[mTexture2 transform] setScale:mScale];
    [[mRenderable2 transform] setAngle:PBVertex3Make(0, 0, mAngle)];
    [mRenderable2 setPosition:CGPointMake(50, 50)];
    
    [[mRenderable3 transform] setScale:mScale];
    [[mRenderable3 transform] setAngle:PBVertex3Make(0, 0, mAngle)];
    [mRenderable3 setPosition:CGPointMake(80, -20)];
    
    [mRenderable1 setSubrenderables:[NSArray arrayWithObjects:mRenderable2, nil]];
    [[self renderable] setSubrenderables:[NSArray arrayWithObjects:mRenderable1, mRenderable3,  nil]];
}


@end
