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
#import "PBException.h"
#import "PBContext.h"


@implementation PBDynamicTexture
{
    id           mDynamicDelegate;
    
    GLubyte     *mData;
    CGContextRef mContext;
    BOOL         mInitialUpdate;
}


@synthesize dynamicDelegate = mDynamicDelegate;
@synthesize context         = mContext;


#pragma mark -


- (void)setupContext
{
    CGSize sImageSize = [self imageSize];
    
    NSAssert(sImageSize.width < 1024, @"");
    NSAssert(sImageSize.height < 1024, @"");
    
    mData = (GLubyte *)calloc(sImageSize.width * sImageSize.height * 4, sizeof(GLubyte));
    if (mData)
    {
        CGColorSpaceRef sColorSpace = CGColorSpaceCreateDeviceRGB();
        mContext = CGBitmapContextCreate(mData, sImageSize.width, sImageSize.height, 8, sImageSize.width * 4, sColorSpace, kCGImageAlphaPremultipliedLast);
        CGColorSpaceRelease(sColorSpace);
    }
    else
    {
        NSLog(@"error");
    }
    
    mInitialUpdate = YES;
    
    if ([mDynamicDelegate respondsToSelector:@selector(texture:didChangeContext:)])
    {
        [mDynamicDelegate texture:self didChangeContext:mContext];
    }
}


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
    self = [super initWithSize:aSize scale:aScale];
    
    if (self)
    {
        [self setupContext];
        [self update];
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
    CGSize sImageSize = [self imageSize];
    CGRect sRect      = CGRectMake(0, 0, sImageSize.width, sImageSize.height);
    
    if (mDynamicDelegate)
    {
        [mDynamicDelegate texture:self drawInRect:sRect context:mContext];
    }
    else
    {
        [self drawInRect:sRect context:mContext];
    }
    
    [PBContext performBlockOnMainThread:^{
        glBindTexture(GL_TEXTURE_2D, [self handle]);
        
        if (mInitialUpdate)
        {
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, sImageSize.width, sImageSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, mData);
            mInitialUpdate = NO;
        }
        else
        {
            glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, sImageSize.width, sImageSize.height, GL_RGBA, GL_UNSIGNED_BYTE, mData);
        }
    }];
}


- (void)setSize:(CGSize)aSize
{
    if (!CGSizeEqualToSize(mSize, aSize))
    {
        mSize = aSize;
        mImageSize.width  = (NSInteger)(mSize.width  * mImageScale + 0.5);
        mImageSize.height = (NSInteger)(mSize.height * mImageScale + 0.5);
        
        [self clearContext];
        [self setupContext];

        [[self delegate] textureDidResize:self];
    }
}


#pragma mark -


- (void)drawInRect:(CGRect)aRect context:(CGContextRef)aContext
{

}


@end
