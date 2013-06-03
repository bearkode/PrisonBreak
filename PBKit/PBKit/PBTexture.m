/*
 *  PBTexture.m
 *  PBKit
 *
 *  Created by bearkode on 13. 1. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTexture.h"
#import "PBTextureUtils.h"
#import "PBVertices.h"
#import "PBGLObjectManager.h"


@implementation PBTexture
{
    /*  Loader  */
    id        mSource;
    SEL       mSourceLoader;
    BOOL      mLoaded;
    NSInteger mRetryCount;
    
    id        mDelegate;
}


@synthesize handle     = mHandle;
@synthesize loaded     = mLoaded;
@synthesize retryCount = mRetryCount;
@synthesize delegate   = mDelegate;


#pragma mark -
#pragma mark Private


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
    NSAssert(aImageName, @"");
    
    self = [self init];
    
    if (self)
    {
        mSource       = [aImageName copy];
        mSourceLoader = @selector(loadWithName);
    }
    
    return self;
}


- (id)initWithPath:(NSString *)aPath
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


- (id)initWithSize:(CGSize)aSize scale:(CGFloat)aScale
{
    self = [self init];
    
    if (self)
    {
        mHandle     = PBTextureCreate();
        mImageScale = aScale;
        mLoaded     = YES;

        mSize             = aSize;
        mImageSize.width  = aSize.width  * aScale;
        mImageSize.height = aSize.height * aScale;
    }
    
    return self;
}


- (void)dealloc
{
    [mSource release];
    [[PBGLObjectManager sharedManager] deleteTexture:mHandle];
    
    [super dealloc];
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


- (CGSize)size
{
    return mSize;
}


#pragma mark -


- (CGSize)imageSize
{
    return mImageSize;
}


- (CGFloat)imageScale
{
    return mImageScale;
}


#pragma mark -
#pragma mark Loaders


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

        mSize = mImageSize;
        mSize.width  /= mImageScale;
        mSize.height /= mImageScale;
        
        mLoaded = YES;
        [mDelegate textureDidLoad:self];
    }
}


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


@end
