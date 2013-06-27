/*
 *  PBColor.h
 *  PBKit
 *
 *  Created by Park Heon-jun on 12. 7. 13..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "PBColor.h"


@implementation PBColor
{
    GLfloat mRed;
    GLfloat mGreen;
    GLfloat mBlue;
    GLfloat mAlpha;
}


@synthesize r = mRed;
@synthesize g = mGreen;
@synthesize b = mBlue;
@synthesize a = mAlpha;


#pragma mark -


+ (PBColor *)colorWithWhite:(GLfloat)aWhite alpha:(GLfloat)aAlpha
{
    return [[[self alloc] initWithWhite:aWhite alpha:aAlpha] autorelease];
}


+ (PBColor *)colorWithRed:(GLfloat)aRed green:(GLfloat)aGreen blue:(GLfloat)aBlue alpha:(GLfloat)aAlpha
{
    return [[[self alloc] initWithRed:aRed green:aGreen blue:aBlue alpha:aAlpha] autorelease];
}


+ (PBColor *)colorWithRGB:(int)aRGB alpha:(GLfloat)aAlpha
{
    return [[[self alloc] initWithRGB:aRGB alpha:aAlpha] autorelease];
}


+ (PBColor *)blackColor
{
    static PBColor         *sColor;
    static dispatch_once_t  sOnce;

    dispatch_once(&sOnce, ^{
            sColor = [[self alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        });

    return sColor;
}


+ (PBColor *)darkGrayColor
{
    static PBColor         *sColor;
    static dispatch_once_t  sOnce;

    dispatch_once(&sOnce, ^{
            sColor = [[self alloc] initWithRed:(1.0 / 3.0) green:(1.0 / 3.0) blue:(1.0 / 3.0) alpha:1.0];
        });

    return sColor;
}


+ (PBColor *)lightGrayColor
{
    static PBColor         *sColor;
    static dispatch_once_t  sOnce;

    dispatch_once(&sOnce, ^{
            sColor = [[self alloc] initWithRed:(2.0 / 3.0) green:(2.0 / 3.0) blue:(2.0 / 3.0) alpha:1.0];
        });

    return sColor;
}


+ (PBColor *)whiteColor
{
    static PBColor         *sColor;
    static dispatch_once_t  sOnce;

    dispatch_once(&sOnce, ^{
            sColor = [[self alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        });

    return sColor;
}


+ (PBColor *)grayColor
{
    static PBColor         *sColor;
    static dispatch_once_t  sOnce;

    dispatch_once(&sOnce, ^{
            sColor = [[self alloc] initWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        });

    return sColor;
}


+ (PBColor *)redColor
{
    static PBColor         *sColor;
    static dispatch_once_t  sOnce;

    dispatch_once(&sOnce, ^{
            sColor = [[self alloc] initWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        });

    return sColor;
}


+ (PBColor *)greenColor
{
    static PBColor         *sColor;
    static dispatch_once_t  sOnce;

    dispatch_once(&sOnce, ^{
            sColor = [[self alloc] initWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
        });

    return sColor;
}


+ (PBColor *)blueColor
{
    static PBColor         *sColor;
    static dispatch_once_t  sOnce;

    dispatch_once(&sOnce, ^{
            sColor = [[self alloc] initWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
        });

    return sColor;
}


+ (PBColor *)cyanColor
{
    static PBColor         *sColor;
    static dispatch_once_t  sOnce;

    dispatch_once(&sOnce, ^{
            sColor = [[self alloc] initWithRed:0.0 green:1.0 blue:1.0 alpha:1.0];
        });

    return sColor;
}


+ (PBColor *)yellowColor
{
    static PBColor         *sColor;
    static dispatch_once_t  sOnce;

    dispatch_once(&sOnce, ^{
            sColor = [[self alloc] initWithRed:1.0 green:1.0 blue:0.0 alpha:1.0];
        });

    return sColor;
}


+ (PBColor *)magentaColor
{
    static PBColor         *sColor;
    static dispatch_once_t  sOnce;

    dispatch_once(&sOnce, ^{
            sColor = [[self alloc] initWithRed:1.0 green:0.0 blue:1.0 alpha:1.0];
        });

    return sColor;
}


+ (PBColor *)orangeColor
{
    static PBColor         *sColor;
    static dispatch_once_t  sOnce;

    dispatch_once(&sOnce, ^{
            sColor = [[self alloc] initWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
        });

    return sColor;
}


+ (PBColor *)purpleColor
{
    static PBColor         *sColor;
    static dispatch_once_t  sOnce;

    dispatch_once(&sOnce, ^{
            sColor = [[self alloc] initWithRed:0.5 green:0.0 blue:0.5 alpha:1.0];
        });

    return sColor;
}


+ (PBColor *)brownColor
{
    static PBColor         *sColor;
    static dispatch_once_t  sOnce;

    dispatch_once(&sOnce, ^{
            sColor = [[self alloc] initWithRed:0.6 green:0.4 blue:0.2 alpha:1.0];
        });

    return sColor;
}


+ (PBColor *)clearColor
{
    static PBColor         *sColor;
    static dispatch_once_t  sOnce;

    dispatch_once(&sOnce, ^{
            sColor = [[self alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
        });

    return sColor;
}


+ (PBColor *)currentColor
{
    GLfloat sValue[4];

    glGetFloatv(GL_CURRENT_COLOR, sValue);

    return [self colorWithRed:sValue[0] green:sValue[1] blue:sValue[2] alpha:sValue[3]];
}


#pragma mark -


- (id)initWithWhite:(GLfloat)aWhite alpha:(GLfloat)aAlpha
{
    self = [super init];

    if (self)
    {
        mRed   = aWhite;
        mGreen = aWhite;
        mBlue  = aWhite;
        mAlpha = aAlpha;
    }

    return self;
}


- (id)initWithRed:(GLfloat)aRed green:(GLfloat)aGreen blue:(GLfloat)aBlue alpha:(GLfloat)aAlpha
{
    self = [super init];

    if (self)
    {
        mRed   = aRed;
        mGreen = aGreen;
        mBlue  = aBlue;
        mAlpha = aAlpha;
    }

    return self;
}


- (id)initWithRGB:(int)aRGB alpha:(GLfloat)aAlpha
{
    self = [super init];

    if (self)
    {
        mRed   = ((aRGB >> 16) & 0xff) / 255.0;
        mGreen = ((aRGB >> 8)  & 0xff) / 255.0;
        mBlue  = ((aRGB)       & 0xff) / 255.0;
        mAlpha = aAlpha;
    }

    return self;
}


@end
