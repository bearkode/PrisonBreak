/*
 *  PBDynamicTexture.m
 *  PBKit
 *
 *  Created by bearkcode on 13. 2. 5..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBDynamicTexture.h"
#import "PBTextureUtils.h"


@implementation PBDynamicTexture
{
    CGSize       mSize;
    GLubyte     *mData;
    CGContextRef mContext;
}


@synthesize context = mContext;


#pragma mark -


- (id)initWithSize:(CGSize)aSize
{
    self = [super init];
    
    if (self)
    {
        mTextureID = PBCreateEmptyTexture();

        if (![self setSize:aSize])
        {
            [self release];
            return nil;
        }
    }
    
    return self;
}


- (void)dealloc
{
    CGContextRelease(mContext);
    if (mData)
    {
        free(mData);
    }

    [super dealloc];
}


#pragma mark -


- (void)update
{
    [self drawInContext:mContext size:mSize];

    dispatch_async(dispatch_get_main_queue(), ^{
        glBindTexture(GL_TEXTURE_2D, mTextureID);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, mSize.width, mSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, mData);
    });
}


- (BOOL)setSize:(CGSize)aSize
{
    mSize = aSize;
    [self setTileSize:mSize];
    
    if (mData)
    {
        free(mData);
    }

    mData = (GLubyte *)calloc(mSize.width * mSize.height * 4, sizeof(GLubyte));
    if (mData)
    {
        CGColorSpaceRef sColorSpace = CGColorSpaceCreateDeviceRGB();
        mContext = CGBitmapContextCreate(mData, mSize.width, mSize.height, 8, mSize.width * 4, sColorSpace, kCGImageAlphaPremultipliedLast);
        CGColorSpaceRelease(sColorSpace);
        
        return YES;
    }
    else
    {
        return NO;
    }
}


#pragma mark -


- (void)drawInContext:(CGContextRef)aContext size:(CGSize)aSize
{

}


@end
