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


@implementation PBTexture
{
    id      mSource;
    SEL     mSourceLoader;
    
    CGFloat mScale;
    CGFloat mImageScale;
}


@synthesize textureID  = mTextureID;
@synthesize imageSize  = mImageSize;
@synthesize scale      = mScale;
@synthesize imageScale = mImageScale;


#pragma mark -


+ (id)textureNamed:(NSString *)aName
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
        mScale      = [[UIScreen mainScreen] scale];
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


- (id)initWithPath:(NSString *)aPath
{
    self = [self init];
    
    if (self)
    {
        mSource       = [aPath copy];
        mSourceLoader = (PBIsPVRFile(aPath)) ? @selector(loadWithPVRPath) : @selector(loadWithImagePath);
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


- (id)initWithImageName:(NSString *)aImageName scale:(CGFloat)aScale
{
    self = [self initWithImageName:aImageName];
    
    if (self)
    {
        if (aScale == 0)
        {
            aScale = [[UIScreen mainScreen] scale];
        }
        
        mScale = aScale;
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
    
    mImageSize = PBImageSizeFromCGImage(aImage);
    mSize      = mImageSize;
    mTextureID = PBCreateTexture(mSize, sData);
    
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
    mSize.width  *= mScale / mImageScale;
    mSize.height *= mScale / mImageScale;
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

    mTextureID = PBCreateTextureWithPVRUnpackResult(sResult);
    mImageSize = CGSizeMake([sResult width],  [sResult height]);
    mSize      = mImageSize;

    [self finishLoad];
}


- (void)loadWithImage
{
    [self setTextureWithImage:[(UIImage *)mSource CGImage]];
    [self finishLoad];
}


#pragma mark -


- (id)load
{
    if (mSourceLoader)
    {
        [self performSelector:mSourceLoader];
    }
    else
    {
        NSLog(@"Unknown Texture Source");
    }
    
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


@end
