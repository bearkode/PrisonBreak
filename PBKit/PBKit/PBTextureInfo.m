/*
 *  PBTextureInfo.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 13..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTextureInfo.h"
#import "PBContext.h"
#import "PBTextureUtils.h"


@implementation PBTextureInfo
{
    GLuint  mHandle;
    CGSize  mImageSize;
    CGFloat mImageScale;
    
    id      mSource;
    SEL     mSourceLoader;
}


@synthesize handle     = mHandle;
@synthesize imageSize  = mImageSize;
@synthesize imageScale = mImageScale;


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mHandle     = 0;
        mImageSize  = CGSizeZero;
        mImageScale = 1.0;
    }
    
    return self;
}


- (id)initWithImageName:(NSString *)aImageName
{
    self = [self init];
    
    if (self)
    {
        mSource       = [aImageName copy];
        mSourceLoader = @selector(loadWithName);
    }
    
    return self;
}


- (id)initWithPath:(NSString *)aPath scale:(CGFloat)aScale
{
    self = [self init];
    
    if (self)
    {
        mSource       = [aPath copy];
        mSourceLoader = @selector(loadWithImagePath);
    }
    
    return self;
}


- (id)initWithImage:(UIImage *)aImage
{
    self = [self init];
    
    if (self)
    {
        mSource       = [aImage retain];
        mSourceLoader = @selector(loadWithImage);
    }
    
    return self;
}


- (id)initWithSize:(CGSize)aSize scale:(CGFloat)aScale
{
    self = [self init];
    
    if (self)
    {
        mHandle     = PBCreateEmptyTexture();
        mImageSize  = aSize;
        mImageScale = aScale;
    }
    
    return self;
}


- (void)dealloc
{
    [mSource release];
    PBTextureRelease(mHandle);
    
    [super dealloc];
}


#pragma mark -


- (void)setTextureWithImage:(CGImageRef)aImage
{
    GLubyte *sData = PBCreateImageDataFromCGImage(aImage);
    
    mImageSize = PBImageSizeFromCGImage(aImage);
    mHandle    = PBCreateTexture(mImageSize, sData);
    
    PBImageDataRelease(sData);
}


- (void)finishLoad
{
    [mSource release];
    mSource = nil;
}


#pragma mark -


- (void)loadWithName
{
    UIImage *sImage = [UIImage imageNamed:(NSString *)mSource];
    
    [self setTextureWithImage:[sImage CGImage]];
    
    [self finishLoad];
    
    mImageScale = [sImage scale];
}


- (void)loadWithImagePath
{
    UIImage *sImage = [UIImage imageWithContentsOfFile:(NSString *)mSource];
    
    [self setTextureWithImage:[sImage CGImage]];
    
    [self finishLoad];
}


- (void)loadWithPVRPath
{
    PBPVRUnpackResult *sResult = PBUnpackPVRData([NSData dataWithContentsOfFile:(NSString *)mSource]);
    
    mHandle    = PBCreateTextureWithPVRUnpackResult(sResult);
    mImageSize = CGSizeMake([sResult width],  [sResult height]);
    
    [self finishLoad];
}


- (void)loadWithImage
{
    [self setTextureWithImage:[(UIImage *)mSource CGImage]];
    
    [self finishLoad];
}


#pragma mark -


- (void)load
{
    NSAssert(mSourceLoader, @"");
    
    if (mSourceLoader)
    {
        [self performSelector:mSourceLoader];
    }
}


@end
