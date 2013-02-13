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


- (id)initWithTextureInfo:(PBTextureInfo *)aTextureInfo
{
    self = [self init];
    
    if (self)
    {
        mTextureInfo = [aTextureInfo retain];
    }
    
    return self;
}


- (void)dealloc
{
    [mTextureInfo release];

    [super dealloc];
}


#pragma mark -


- (id)load
{
    [[self textureInfo] load];
    
    mSize = [self imageSize];
    
    mSize.width  *= mScale / [mTextureInfo imageScale];
    mSize.height *= mScale / [mTextureInfo imageScale];

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
