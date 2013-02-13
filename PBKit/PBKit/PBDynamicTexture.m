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
#import "PBTextureInfo.h"
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


- (id)initWithSize:(CGSize)aSize scale:(CGFloat)aScale
{
    self = [super initWithImageSize:aSize scale:aScale];
    
    if (self)
    {
        [self setSize:aSize];
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
        glBindTexture(GL_TEXTURE_2D, [self handle]);
        
        if (mResized)
        {
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, mSize.width, mSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, mData);
            mResized = NO;            
        }
        else
        {
            glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, mSize.width, mSize.height, GL_RGBA, GL_UNSIGNED_BYTE, mData);
        }
    });
}


- (void)setSize:(CGSize)aSize
{
    NSAssert(aSize.width < 1024, @"");
    NSAssert(aSize.height < 1024, @"");
    
    if (!CGSizeEqualToSize(mSize, aSize))
    {
        [self willChangeValueForKey:@"size"];
        
        mResized = YES;
        mSize    = aSize;
        [[self textureInfo] setImageSize:mSize];
        
        [self clearContext];
        
        mData = (GLubyte *)calloc(mSize.width * mSize.height * 4, sizeof(GLubyte));
        if (mData)
        {
            CGColorSpaceRef sColorSpace = CGColorSpaceCreateDeviceRGB();
            mContext = CGBitmapContextCreate(mData, mSize.width, mSize.height, 8, mSize.width * 4, sColorSpace, kCGImageAlphaPremultipliedLast);
            CGColorSpaceRelease(sColorSpace);
        }
        
        [self didChangeValueForKey:@"size"];
    }
}


#pragma mark -


- (void)drawInContext:(CGContextRef)aContext bounds:(CGRect)aBounds
{
    SubclassResponsibility();
}


@end
