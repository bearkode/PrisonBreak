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
    PBVertex3 mTranslate;
    PBColor  *mColor;
    BOOL      mGrayscale;
    BOOL      mSepia;
    BOOL      mBlur;
    BOOL      mLuminance;
}


@synthesize angle     = mAngle;
@synthesize translate = mTranslate;
@synthesize scale     = mScale;
@synthesize color     = mColor;
@synthesize grayscale = mGrayscale;
@synthesize sepia     = mSepia;
@synthesize blur      = mBlur;
@synthesize luminance = mLuminance;


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
        mAngle     = PBVertex3Zero;
        mTranslate = PBVertex3Zero;
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
