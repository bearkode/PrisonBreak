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


- (void)setTextureInfo:(PBTextureInfo *)aTextureInfo
{
    [mTextureInfo removeObserver:self forKeyPath:kPBTextureInfoLoadedKey];
    [mTextureInfo autorelease];
    
    mTextureInfo = [aTextureInfo retain];
    [mTextureInfo addObserver:self forKeyPath:kPBTextureInfoLoadedKey options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
}


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        memcpy(mVertices, gTextureVertices, sizeof(GLfloat) * 8);
        mScale = 1;//[[UIScreen mainScreen] scale];
    }
    
    return self;
}


- (id)initWithImageName:(NSString *)aImageName
{
    self = [self init];
    
    if (self)
    {
        PBTextureInfo *sTextureInfo = [[[PBTextureInfo alloc] initWithImageName:aImageName] autorelease];
        [self setTextureInfo:sTextureInfo];
    }
    
    return self;
}


- (id)initWithPath:(NSString *)aPath
{
    self = [self init];
    
    if (self)
    {
        PBTextureInfo *sTextureInfo = [[[PBTextureInfo alloc] initWithPath:aPath scale:1.0] autorelease];
        [self setTextureInfo:sTextureInfo];
    }
    
    return self;
}


- (id)initWithImage:(UIImage *)aImage
{
    self = [self init];
    
    if (self)
    {
        PBTextureInfo *sTextureInfo = [[[PBTextureInfo alloc] initWithImage:aImage] autorelease];
        [self setTextureInfo:sTextureInfo];
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
        PBTextureInfo *sTextureInfo = [[[PBTextureInfo alloc] initWithSize:aSize scale:aScale] autorelease];
        [self setTextureInfo:sTextureInfo];
    }
    
    return self;
}


- (id)initWithTextureInfo:(PBTextureInfo *)aTextureInfo
{
    self = [self init];
    
    if (self)
    {
        [self setTextureInfo:aTextureInfo];
    }
    
    return self;
}


- (void)dealloc
{
    [mTextureInfo removeObserver:self forKeyPath:kPBTextureInfoLoadedKey];
    [mTextureInfo release];

    [super dealloc];
}


#pragma mark -


- (void)setupSize
{
    mSize = [self imageSize];
    
    mSize.width  *= mScale / [mTextureInfo imageScale];
    mSize.height *= mScale / [mTextureInfo imageScale];
}


- (id)load
{
    [[self textureInfo] loadIfNeeded];

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


#pragma mark -


- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)aObject change:(NSDictionary *)aChange context:(void *)aContext
{
    if ([aKeyPath isEqualToString:kPBTextureInfoLoadedKey] && aObject == mTextureInfo)
    {
        [self setupSize];
    }
}


@end
