/*
 *  PVRTextureView.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 1. 24..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PVRTextureView.h"


@implementation PVRTextureView
{
    PBRenderable *mRenderable;
    PBTexture    *mTexture;
    CGFloat       mScale;
    CGFloat       mAngle;
}


@synthesize scale = mScale;
@synthesize angle = mAngle;


#pragma mark -


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
        
        NSString *sPath = [[NSBundle mainBundle] pathForResource:@"brown" ofType:@"pvr"];
        mTexture = [[PBTexture alloc] initWithPath:sPath];
        [mTexture load];
        
        mRenderable = [[PBRenderable alloc] initWithTexture:mTexture];
        [mRenderable setProgramObject:[[[PBShaderManager sharedManager] textureShader] programObject]];

        [mRenderable setBlendModeSFactor:GL_SRC_ALPHA];
        [mRenderable setBlendModeDFactor:GL_ONE_MINUS_SRC_ALPHA];
        
        [[self renderable] setSubrenderables:[NSArray arrayWithObject:mRenderable]];
    }
    
    return self;
}


- (void)dealloc
{
    [mRenderable release];
    [mTexture release];

    [super dealloc];
}


#pragma mark -


- (void)pbViewUpdate:(PBView *)aView timeInterval:(CFTimeInterval)aTimeInterval displayLink:(CADisplayLink *)aDisplayLink
{
    [[mRenderable transform] setScale:mScale];
    [[mRenderable transform] setAngle:PBVertex3Make(0, 0, mAngle)];
    [mRenderable  setPosition:CGPointMake(0, 0)];
}


@end
