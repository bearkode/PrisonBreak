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
    id  mSource;
    SEL mSourceLoader;
}


@synthesize textureID = mTextureID;
@synthesize size      = mSize;


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
    
    mTileSize = mSize;
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


- (void)setTileSize:(CGSize)aTileSize
{
    [self willChangeValueForKey:@"tileSize"];
    
    mTileSize = aTileSize;
    
    [self didChangeValueForKey:@"tileSize"];
}


- (CGSize)tileSize
{
    return mTileSize;
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
