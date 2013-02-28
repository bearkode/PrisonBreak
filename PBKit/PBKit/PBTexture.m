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


NSString *const kPBTextureLoadedKey = @"loaded";


@implementation PBTexture
{
    GLuint         mHandle;
    CGSize         mImageSize;
    CGFloat        mImageScale;
    CGSize         mSize;
    
    /*  Loader  */
    id             mSource;
    SEL            mSourceLoader;
    BOOL           mLoaded;
    NSInteger      mRetryCount;    
}


@synthesize loaded     = mLoaded;
@synthesize retryCount = mRetryCount;


#pragma mark -


//- (void)setTextureInfo:(PBTextureI *)aTextureI
//{
//    [mTextureI removeObserver:self forKeyPath:kPBTextureILoadedKey];
//    [mTextureI autorelease];
//    
//    mTextureI = [aTextureInfo retain];
//    [mTextureI addObserver:self forKeyPath:kPBTextureILoadedKey options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
//    
//    if ([mTextureI isLoaded])
//    {
//        [self setupMesh];
//    }
//}


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


- (id)initWithImageSize:(CGSize)aSize scale:(CGFloat)aScale
{
    self = [self init];
    
    if (self)
    {
        mHandle     = PBTextureCreate();
        mImageScale = aScale;
        mLoaded     = YES;
        
        mImageSize.width  = aSize.width  * aScale;
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


#pragma mark -


- (void)setup
{
    mSize = mImageSize;
    mSize.width  /= mImageScale;
    mSize.height /= mImageScale;
}


- (id)load
{
    [self loadIfNeeded];

    return self;
}


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


- (void)setSize:(CGSize)aSize
{
    mSize = aSize;
}


#pragma mark -


- (GLuint)handle
{
    return mHandle;
}


- (CGSize)imageSize
{
    return mImageSize;
}


- (void)setImageSize:(CGSize)aImageSize
{
    mImageSize = aImageSize;
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

        [self setup];
        
        [self willChangeValueForKey:kPBTextureLoadedKey];
        mLoaded = YES;
        [self didChangeValueForKey:kPBTextureLoadedKey];
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
