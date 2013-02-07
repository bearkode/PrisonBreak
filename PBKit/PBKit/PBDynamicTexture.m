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
#import "PBObjCUtil.h"


@implementation PBDynamicTexture
{
    GLubyte     *mData;
    CGContextRef mContext;
    BOOL         mResized;
}


@synthesize context = mContext;


#pragma mark -


- (void)clearContext
{
    CGContextRelease(mContext);

    if (mData)
    {
        free(mData);
    }
}


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
    [self clearContext];

    [super dealloc];
}


#pragma mark -


- (void)update
{
    [self drawInContext:mContext bounds:CGRectMake(0, 0, mSize.width, mSize.height)];

    dispatch_async(dispatch_get_main_queue(), ^{
        glBindTexture(GL_TEXTURE_2D, mTextureID);
        
        if (mResized)
        {
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, mSize.width, mSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, mData);
        }
        else
        {
            glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, mSize.width, mSize.height, GL_RGBA, GL_UNSIGNED_BYTE, mData);
        }
        
        mResized = NO;
    });
}


- (BOOL)setSize:(CGSize)aSize
{
    BOOL sResult = YES;
    
    if (!CGSizeEqualToSize(mSize, aSize))
    {
        mResized = YES;
        mSize    = aSize;
        
        [self setTileSize:mSize];
        [self clearContext];
        
        mData = (GLubyte *)calloc(mSize.width * mSize.height * 4, sizeof(GLubyte));
        if (mData)
        {
            CGColorSpaceRef sColorSpace = CGColorSpaceCreateDeviceRGB();
            mContext = CGBitmapContextCreate(mData, mSize.width, mSize.height, 8, mSize.width * 4, sColorSpace, kCGImageAlphaPremultipliedLast);
            CGColorSpaceRelease(sColorSpace);
        }
        else
        {
            sResult = NO;
        }
    }
    
    return sResult;
}


#pragma mark -


- (void)drawInContext:(CGContextRef)aContext bounds:(CGRect)aBounds
{
    SubclassResponsibility();
}


@end
