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
#import "PBVertice.h"


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
    GLfloat             mVertices[8];
}


@synthesize textureID = mTextureID;
@synthesize size      = mSize;


#pragma mark -


- (id)initWithImageName:(NSString *)aImageName
{
    self = [super init];
    
    if (self)
    {
        mSource       = [aImageName copy];
        mSourceType   = kPBTextureSourceTypeName;
        mSourceLoader = @selector(loadWithName);
        
        memcpy(mVertices, gTextureVertices, sizeof(GLfloat) * 8);
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
        
        memcpy(mVertices, gTextureVertices, sizeof(GLfloat) * 8);        
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
        
        memcpy(mVertices, gTextureVertices, sizeof(GLfloat) * 8);        
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
    mSize      = CGSizeMake([sResult width],  [sResult height]);

    [self finishLoad];
}


- (void)loadWithImage
{
    [self setTextureWithImage:[(UIImage *)mSource CGImage]];
    [self finishLoad];
}


//+ (PBTexture *)textureWithColor:(PBColor *)aColor
//{
//    GLubyte *sData = (GLubyte *) calloc(1 * 1, sizeof(GLubyte));
//
//    sData[0] = [aColor red] * 255;
//    sData[1] = [aColor green] * 255;
//    sData[2] = [aColor blue] * 255;
//    sData[3] = [aColor alpha] * 255;
//
//    GLuint sTextureID = PBCreateTexture(CGSizeMake(1, 1), sData);
//
////    glPixelStorei ( GL_UNPACK_ALIGNMENT, 1 );
////    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
////    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
////    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_MIRRORED_REPEAT);
////    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_MIRRORED_REPEAT);
////    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 1, 1, 0, GL_RGB, GL_UNSIGNED_BYTE, sTextureData);
//
//    return [[[PBTexture alloc] initWithTextureID:sTextureID size:CGSizeMake(1, 1)] autorelease];
//}


#pragma mark -


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
}


#pragma mark -


- (GLfloat *)vertices
{
#if (0)
    static GLfloat sVertices[8];
    
    for (NSInteger i = 0; i < 8; i++)
    {
        sVertices[i] = mVertices[i] / 2;
    }
    
    return sVertices;
#else
    return mVertices;
#endif
}


@end
