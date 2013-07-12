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
    CGFloat   mScale;
    PBVertex3 mAngle;
    PBVertex3 mTranslate;
    PBColor  *mColor;
    CGFloat   mAlpha;
    BOOL      mGrayscale;
    BOOL      mSepia;
    BOOL      mBlur;
    
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
        mScale     = 1.0f;
        mAlpha     = 1.0f;
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


- (void)setScale:(CGFloat)aScale
{
    mScale = aScale;
    
    mDirty = YES;
}


- (CGFloat)scale
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
    [mColor autorelease];
    mColor = [[PBColor colorWithWhite:aAlpha alpha:aAlpha] retain];
    
    mDirty = YES;
}


- (CGFloat)alpha
{
    return mAlpha;
}


@end
