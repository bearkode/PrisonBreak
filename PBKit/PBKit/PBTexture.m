/*
 *  PBTexture.m
 *  PBKit
 *
 *  Created by bearkode on 13. 1. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTexture.h"
#import "PBTextureInfo.h"
#import "PBTextureUtils.h"
#import "PBVertices.h"


@implementation PBTexture
{
    PBTextureInfo *mTextureInfo;
    CGFloat        mScale;
}


@synthesize scale = mScale;


#pragma mark -


+ (id)textureWithImageName:(NSString *)aName
{
    return [[[self alloc] initWithImageName:aName] autorelease];
}


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        memcpy(mVertices, gTextureVertices, sizeof(GLfloat) * 8);
        mScale = [[UIScreen mainScreen] scale];
    }
    
    return self;
}


- (id)initWithImageName:(NSString *)aImageName
{
    self = [self init];
    
    if (self)
    {
        mTextureInfo = [[PBTextureInfo alloc] initWithImageName:aImageName];
    }
    
    return self;
}


- (id)initWithPath:(NSString *)aPath
{
    self = [self init];
    
    if (self)
    {
        mTextureInfo = [[PBTextureInfo alloc] initWithPath:aPath scale:1.0];
    }
    
    return self;
}


- (id)initWithImage:(UIImage *)aImage
{
    self = [self init];
    
    if (self)
    {
        mTextureInfo = [[PBTextureInfo alloc] initWithImage:aImage];
    }
    
    return self;
}


- (id)initWithImageName:(NSString *)aImageName scale:(CGFloat)aScale
{
    self = [self initWithImageName:aImageName];
    
    if (self)
    {
        if (aScale)
        {
            mScale = aScale;
        }
    }
    
    return self;
}


- (id)initWithImageSize:(CGSize)aSize scale:(CGFloat)aScale
{
    self = [self init];
    
    if (self)
    {
        mTextureInfo = [[PBTextureInfo alloc] initWithSize:aSize scale:aScale];
    }
    
    return self;
}


- (void)dealloc
{
    [mTextureInfo release];

    [super dealloc];
}


#pragma mark -


//- (void)setTextureWithImage:(CGImageRef)aImage
//{
//    GLubyte *sData = PBCreateImageDataFromCGImage(aImage);
//    
//    mImageSize = PBImageSizeFromCGImage(aImage);
//    mSize      = mImageSize;
//    mTextureID = PBCreateTexture(mSize, sData);
//    
//    PBImageDataRelease(sData);
//}
//
//
//- (void)finishLoad
//{
//    [mSource release];
//    mSource = nil;
//}


#pragma mark -


//- (void)loadWithName
//{
//    UIImage *sImage = [UIImage imageNamed:(NSString *)mSource];
//
//    [self setTextureWithImage:[sImage CGImage]];
//    [self finishLoad];
//    
//    mImageScale = [sImage scale];
//    mSize.width  *= mScale / mImageScale;
//    mSize.height *= mScale / mImageScale;
//}
//
//
//- (void)loadWithImagePath
//{
//    UIImage *sImage = [UIImage imageWithContentsOfFile:(NSString *)mSource];
//    
//    [self setTextureWithImage:[sImage CGImage]];
//    [self finishLoad];
//}
//
//
//- (void)loadWithPVRPath
//{
//    PBPVRUnpackResult *sResult = PBUnpackPVRData([NSData dataWithContentsOfFile:(NSString *)mSource]);
//
//    mTextureID = PBCreateTextureWithPVRUnpackResult(sResult);
//    mImageSize = CGSizeMake([sResult width],  [sResult height]);
//    mSize      = mImageSize;
//
//    [self finishLoad];
//}
//
//
//- (void)loadWithImage
//{
//    [self setTextureWithImage:[(UIImage *)mSource CGImage]];
//    [self finishLoad];
//}


#pragma mark -


- (id)load
{
//    if (mSourceLoader)
//    {
//        [self performSelector:mSourceLoader];
//    }
//    else
//    {
//        NSLog(@"Unknown Texture Source");
//    }
    
    [[self textureInfo] load];
    
    mSize = [self imageSize];
    
    mSize.width  *= mScale / [mTextureInfo imageScale];
    mSize.height *= mScale / [mTextureInfo imageScale];
    
//    NSLog(@"mScale = %f", mScale);
//    NSLog(@"imageScale = %f", [mTextureInfo imageScale]);
//    NSLog(@"mSize = %@", NSStringFromCGSize(mSize));
    
    return self;
}


#pragma mark -


- (CGSize)size
{
    return mSize;
}


- (void)setVertices:(GLfloat *)aVertices
{
    memcpy(mVertices, aVertices, sizeof(GLfloat) * 8);
}


- (GLfloat *)vertices
{
    return mVertices;
}


#pragma mark -


- (PBTextureInfo *)textureInfo
{
    return mTextureInfo;
}


- (GLuint)handle
{
    return [mTextureInfo handle];
}


- (CGSize)imageSize
{
    return [mTextureInfo imageSize];
}


- (CGFloat)imageScale
{
    return [mTextureInfo imageScale];
}


@end
