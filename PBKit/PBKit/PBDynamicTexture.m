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
    id           mDelegate;
    
    GLubyte     *mData;
    CGContextRef mContext;
    BOOL         mResized;
}


@synthesize delegate = mDelegate;
@synthesize context  = mContext;


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
    CGSize sImageSize = [[self textureInfo] imageSize];
    CGRect sRect      = CGRectMake(0, 0, sImageSize.width, sImageSize.height);
    
    if (mDelegate)
    {
        [mDelegate drawInRect:sRect context:mContext];
    }
    else
    {
        [self drawInContext:mContext bounds:sRect];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        glBindTexture(GL_TEXTURE_2D, [self handle]);
        
        if (mResized)
        {
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, sImageSize.width, sImageSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, mData);
            mResized = NO;            
        }
        else
        {
            glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, sImageSize.width, sImageSize.height, GL_RGBA, GL_UNSIGNED_BYTE, mData);
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
        
        CGFloat sImageScale = [self imageScale];
        CGSize  sImageSize  = CGSizeMake(mSize.width * sImageScale, mSize.height * sImageScale);
        
        [[self textureInfo] setImageSize:sImageSize];

        [self clearContext];
        
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
        
        [self didChangeValueForKey:@"size"];
    }
}


#pragma mark -


- (void)drawInContext:(CGContextRef)aContext bounds:(CGRect)aBounds
{
    SubclassResponsibility();
}


@end
