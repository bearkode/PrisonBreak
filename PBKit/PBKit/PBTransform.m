/*
 *  PBTransform.m
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 28..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "PBKit.h"


@implementation PBTransform
{
    CGFloat   mScale;
    PBVertex3 mAngle;
    PBColor  *mColor;
    BOOL      mGrayScaleEffect;
    BOOL      mSepiaEffect;
    BOOL      mLuminanceEffect;
    BOOL      mBlurEffect;
}


@synthesize angle           = mAngle;
@synthesize scale           = mScale;
@synthesize color           = mColor;
@synthesize grayScaleEffect = mGrayScaleEffect;
@synthesize sepiaEffect     = mSepiaEffect;
@synthesize luminanceEffect = mLuminanceEffect;
@synthesize blurEffect      = mBlurEffect;


#pragma mark -


+ (CGFloat)defaultScale
{
    return 1.0f;
}

#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mScale     = 1.0f;
        mAngle     = PBVertex3Make(0, 0, 0);
    }
    
    return self;
}


- (void)dealloc
{
    [mColor release];
    
    [super dealloc];
}


#pragma mark -


- (void)setAlpha:(CGFloat)aAlpha
{
    [mColor autorelease];
    mColor = [[PBColor colorWithWhite:aAlpha alpha:aAlpha] retain];
}


@end
