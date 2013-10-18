/*
 *  PBTransform.m
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 28..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import "PBTransform.h"
#import "PBColor.h"


@implementation PBTransform
{
    PBVertex3 mScale;
    PBVertex3 mAngle;
    PBVertex3 mTranslate;
    PBColor  *mColor;
    CGFloat   mAlpha;
    BOOL      mGrayscale;
    BOOL      mSepia;
    BOOL      mBlur;
    
    BOOL      mHasColor;
    BOOL      mDirty;
}


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
        mAlpha     = 1.0f;
        mScale     = PBVertex3Make(1.0f, 1.0f, 1.0f);
        mAngle     = PBVertex3Zero;
        mTranslate = PBVertex3Zero;
        mDirty     = YES;
    }
    
    return self;
}


- (void)dealloc
{
    [mColor release];
    
    [super dealloc];
}


#pragma mark -


- (void)setScale:(PBVertex3)aScale
{
    mScale = aScale;
    
    mDirty = YES;
}


- (PBVertex3)scale
{
    return mScale;
}


- (void)setAngle:(PBVertex3)aAngle
{
    mAngle = aAngle;
    
    mDirty = YES;
}


- (PBVertex3)angle
{
    return mAngle;
}


- (GLfloat)normalizeAngle:(GLfloat)aAngle
{
    GLfloat sAngle = aAngle;
	if (aAngle > 360.0)
    {
		sAngle = aAngle -  360.0;
	}
    else if (aAngle < 0.0)
    {
        sAngle = aAngle + 360.0;
	}
    
    return sAngle;
}


- (void)setTranslate:(PBVertex3)aTranslate
{
    mTranslate = aTranslate;

    mDirty = YES;
}


- (PBVertex3)translate
{
    return mTranslate;
}


- (void)setColor:(PBColor *)aColor
{
    [mColor autorelease];
    mColor = [aColor retain];

    if (mColor)
    {
        mHasColor = YES;
    }

    mDirty = YES;
}


- (PBColor *)color
{
    return mColor;
}


#pragma mark -


- (void)setDirty:(BOOL)aDirty
{
    mDirty = aDirty;
}


- (BOOL)checkDirty
{
    if (mDirty)
    {
        mDirty = NO;
        
        return YES;
    }
    else
    {
        return NO;
    }
}


- (void)setAlpha:(CGFloat)aAlpha
{
    mAlpha = aAlpha;
    
    if (mHasColor)
    {
        CGFloat sRed   = [mColor r];
        CGFloat sGreen = [mColor g];
        CGFloat sBlue  = [mColor b];

        [mColor autorelease];
        mColor = [[PBColor colorWithRed:sRed green:sGreen blue:sBlue alpha:aAlpha] retain];
    }
    else
    {
        [mColor autorelease];
        mColor = [[PBColor colorWithWhite:aAlpha alpha:aAlpha] retain];
    }
    
    mDirty = YES;
}


- (CGFloat)alpha
{
    return mAlpha;
}


@end
