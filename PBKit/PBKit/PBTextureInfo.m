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
#import "PBGLObjectManager.h"


NSString *const kPBTextureInfoLoadedKey = @"loaded";


@implementation PBTextureInfo
{
    GLuint    mHandle;
    CGSize    mImageSize;
    CGFloat   mImageScale;
    
    id        mSource;
    SEL       mSourceLoader;
    BOOL      mLoaded;
    NSInteger mRetryCount;
}


@synthesize handle     = mHandle;
@synthesize imageSize  = mImageSize;
@synthesize imageScale = mImageScale;
@synthesize loaded     = mLoaded;


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
    NSAssert(aImageName, @"");
    
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
        mSourceLoader = PBIsPVRFile(aPath) ? @selector(loadWithPVRPath) : @selector(loadWithImagePath);
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


- (id)initWithImageSize:(CGSize)aSize scale:(CGFloat)aScale
{
    self = [self init];
    
    if (self)
    {
        mHandle     = PBTextureCreate();
        mImageScale = aScale;
        mLoaded     = YES;
        
        mImageSize.width  = aSize.width * aScale;
        mImageSize.height = aSize.height * aScale;
    }
    
    return self;
}


- (void)dealloc
{
    [mSource release];
    [[PBGLObjectManager sharedManager] removeTexture:mHandle];
    
    [super dealloc];
}


- (NSString *)description
{
    if (mLoaded)
    {
        return [NSString stringWithFormat:@"TextureInfo loaded - [%p]", self];
    }
    else
    {
        return [NSString stringWithFormat:@"TextureInfo not loaded %@ - [%p]", mSource, self];
    }
}


#pragma mark -


- (void)setTextureWithImage:(UIImage *)aImage
{
    if (aImage)
    {
        CGImageRef sImageRef = [aImage CGImage];
        GLubyte   *sData     = NULL;
        
        mImageSize  = PBImageSizeFromCGImage(sImageRef);
        mImageScale = [aImage scale];
        mHandle     = PBTextureCreate();
        
        if (mHandle)
        {
            sData = PBImageDataCreate(sImageRef);
            PBTextureLoad(mHandle, mImageSize, sData);
            PBImageDataRelease(sData);
        }
    }
}


- (void)finishLoad
{
    if (mHandle)
    {
        [mSource release];
        mSource = nil;
    
        [self willChangeValueForKey:kPBTextureInfoLoadedKey];
        mLoaded = YES;
        [self didChangeValueForKey:kPBTextureInfoLoadedKey];
    }
}


#pragma mark -


- (void)loadWithName
{
    NSAssert(mSource, @"");
    
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
    
    mHandle    = PBPVRTextureCreate(sResult);
    mImageSize = CGSizeMake([sResult width],  [sResult height]);
    
    [self finishLoad];
}


- (void)loadWithImage
{
    [self setTextureWithImage:(UIImage *)mSource];
    [self finishLoad];
}


#pragma mark -


- (void)loadIfNeeded
{
    if (!mLoaded)
    {
        NSAssert(mSource, @"");
        NSAssert(mSourceLoader, @"");
        
        if (mSourceLoader)
        {
            [self performSelector:mSourceLoader];
        }
    }
}


#pragma mark -


- (void)setImageSize:(CGSize)aImageSize
{
    mImageSize = aImageSize;
}


@end
