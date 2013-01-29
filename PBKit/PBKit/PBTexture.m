/*
 *  PBTexture.m
 *  PBKit
 *
 *  Created by cgkim on 13. 1. 25..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#import "PBTexture.h"
#import "PBTextureUtils.h"


typedef enum
{
    kPBTextureSourceTypeUnknown = 0,
    kPBTextureSourceTypeName,
    kPBTextureSourceTypePath,
    kPBTextureSourceTypeImage,
} PBTextureSourceType;


@implementation PBTexture
{
    id                  mSource;
    PBTextureSourceType mSourceType;
    SEL                 mSourceLoader;
    
    GLuint              mTextureID;
    CGSize              mSize;
}


@synthesize textureID = mTextureID;
@synthesize size      = mSize;


#pragma mark -


//- (id)initWithTextureID:(GLuint)aTextureID size:(CGSize)aSize
//{
//    self = [super init];
//    
//    if (self)
//    {
//        mTextureID = aTextureID;
//        mSize      = aSize;
//    }
//    
//    return self;
//}


- (id)initWithImageName:(NSString *)aImageName
{
    self = [super init];
    
    if (self)
    {
        mSource       = [aImageName copy];
        mSourceType   = kPBTextureSourceTypeName;
        mSourceLoader = @selector(loadWithName);
    }
    
    return self;
}


- (id)initWithPath:(NSString *)aPath
{
    self = [super init];
    
    if (self)
    {
        mSource     = [aPath copy];
        mSourceType = kPBTextureSourceTypePath;
        
        if (PBIsPVRFile(aPath))
        {
            mSourceLoader = @selector(loadWithPVRPath);
        }
        else
        {
            mSourceLoader = @selector(loadWithImagePath);
        }
    }
    
    return self;
}


- (id)initWithImage:(UIImage *)aImage
{
    self = [super init];
    
    if (self)
    {
        mSource       = [aImage retain];
        mSourceType   = kPBTextureSourceTypeImage;
        mSourceLoader = @selector(loadWithImage);
    }
    
    return self;
}


- (void)dealloc
{
    [mSource release];
    
    PBTextureRelease(mTextureID);
    [super dealloc];
}


#pragma mark -


- (void)setTextureWithImage:(CGImageRef)aImage
{
    GLubyte *sData = PBCreateImageDataFromCGImage(aImage);
    
    mSize      = PBImageSizeFromCGImage(aImage);
    mTextureID = PBCreateTexture(mSize, sData);
    
    PBImageDataRelease(sData);
}


- (void)loadWithName
{
    UIImage *sImage = [UIImage imageNamed:(NSString *)mSource];

    [self setTextureWithImage:[sImage CGImage]];
}


- (void)loadWithImagePath
{
    UIImage *sImage = [UIImage imageWithContentsOfFile:(NSString *)mSource];
    
    [self setTextureWithImage:[sImage CGImage]];
}


- (void)loadWithPVRPath
{
    PBPVRUnpackResult *sResult = PBUnpackPVRData([NSData dataWithContentsOfFile:(NSString *)mSource]);

    mTextureID = PBCreateTextureWithPVRUnpackResult(sResult);
    mSize      = CGSizeMake([sResult width],  [sResult height]);
}


- (void)loadWithImage
{
    [self setTextureWithImage:[(UIImage *)mSource CGImage]];
}


- (void)load
{
    if (mSourceLoader)
    {
        [self performSelector:mSourceLoader];
    }
    else
    {
        NSLog(@"Unknown Texture Source");
    }
    
    NSLog(@"loaded");
}


@end
