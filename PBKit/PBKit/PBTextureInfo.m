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


NSString *const kPBTextureInfoLoadedKey = @"loaded";


@implementation PBTextureInfo
{
    GLuint  mHandle;
    CGSize  mImageSize;
    CGFloat mImageScale;
    
    id      mSource;
    SEL     mSourceLoader;
    BOOL    mLoaded;
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
        mLoaded     = NO;
    }
    
    return self;
}


- (id)initWithImageName:(NSString *)aImageName
{
    self = [self init];
    
    if (self)
    {
        NSLog(@"initWithImageName = %@", aImageName);
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
        NSLog(@"initWithPath = %@", aPath);
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
        NSLog(@"initWithImage = %@", aImage);
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

        mLoaded = YES;
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


- (void)setTextureWithImage:(UIImage *)aImage
{
    CGImageRef sImageRef = [aImage CGImage];
    GLubyte   *sData     = PBCreateImageDataFromCGImage(sImageRef);
    
    mImageSize  = PBImageSizeFromCGImage(sImageRef);
    mImageScale = [aImage scale];
    mHandle     = PBCreateTexture(mImageSize, sData);
    
    PBImageDataRelease(sData);
}


- (void)finishLoad
{
    [mSource release];
    mSource = nil;
    
    [self willChangeValueForKey:kPBTextureInfoLoadedKey];
    mLoaded = YES;
    [self didChangeValueForKey:kPBTextureInfoLoadedKey];
}


#pragma mark -


- (void)loadWithName
{
    UIImage *sImage = [UIImage imageNamed:(NSString *)mSource];
    
    [self setTextureWithImage:sImage];
    [self finishLoad];
}


- (void)loadWithImagePath
{
    UIImage *sImage = [UIImage imageWithContentsOfFile:(NSString *)mSource];
    
    [self setTextureWithImage:sImage];
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
    [self setTextureWithImage:(UIImage *)mSource];
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


#pragma mark -


- (void)setImageSize:(CGSize)aImageSize
{
    mImageSize = aImageSize;
}


@end
