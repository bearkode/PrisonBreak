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
    CGSize         mSize;
    GLfloat        mTexCoords[8];
    GLfloat        mVertices[8];
    PBMesh         mTextureMesh[4];
}


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
    
    if ([mTextureInfo isLoaded])
    {
        [self setupMesh];
    }
}


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        memcpy(mTexCoords, gTextureCoords, sizeof(GLfloat) * 8);
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


- (id)initWithImageSize:(CGSize)aSize scale:(CGFloat)aScale
{
    self = [self init];
    
    if (self)
    {
        PBTextureInfo *sTextureInfo = [[[PBTextureInfo alloc] initWithImageSize:aSize scale:aScale] autorelease];
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


- (void)arrangeTextureMesh
{
    mTextureMesh[0].position[0] = mVertices[0];
    mTextureMesh[0].position[1] = mVertices[1];
    mTextureMesh[1].position[0] = mVertices[2];
    mTextureMesh[1].position[1] = mVertices[3];
    mTextureMesh[2].position[0] = mVertices[4];
    mTextureMesh[2].position[1] = mVertices[5];
    mTextureMesh[3].position[0] = mVertices[6];
    mTextureMesh[3].position[1] = mVertices[7];
    mTextureMesh[0].texCoord[0] = mTexCoords[0];
    mTextureMesh[0].texCoord[1] = mTexCoords[1];
    mTextureMesh[1].texCoord[0] = mTexCoords[2];
    mTextureMesh[1].texCoord[1] = mTexCoords[3];
    mTextureMesh[2].texCoord[0] = mTexCoords[4];
    mTextureMesh[2].texCoord[1] = mTexCoords[5];
    mTextureMesh[3].texCoord[0] = mTexCoords[6];
    mTextureMesh[3].texCoord[1] = mTexCoords[7];
}


- (void)setupMesh
{
    mSize = [mTextureInfo imageSize];
    mSize.width  /= [mTextureInfo imageScale];
    mSize.height /= [mTextureInfo imageScale];

    memcpy(mTexCoords, gTextureCoords, sizeof(GLfloat) * 8);
    [self setVerticesWithSize:mSize];
}


- (id)load
{
    [[self textureInfo] loadIfNeeded];

    return self;
}


#pragma mark -


- (void)setSize:(CGSize)aSize
{
    mSize = aSize;
}


- (CGSize)size
{
    return mSize;
}


- (void)setTexCoords:(GLfloat *)aTexCoords
{
    memcpy(mTexCoords, aTexCoords, sizeof(GLfloat) * 8);
    [self setVerticesWithSize:mSize];
    [self arrangeTextureMesh];
}


- (GLfloat *)texCoords
{
    return mTexCoords;
}


- (void)setVerticesWithSize:(CGSize)aSize
{
    mVertices[0] = -(aSize.width / 2);
    mVertices[1] = (aSize.height / 2);
    mVertices[2] = -(aSize.width / 2);
    mVertices[3] = -(aSize.height / 2);
    mVertices[4] = (aSize.width / 2);
    mVertices[5] = -(aSize.height / 2);
    mVertices[6] = (aSize.width / 2);
    mVertices[7] = (aSize.height / 2);
    [self arrangeTextureMesh];
}


- (void)setVertices:(GLfloat *)aVertices
{
    memcpy(mVertices, aVertices, sizeof(GLfloat) * 8);
    [self arrangeTextureMesh];
}


- (GLfloat *)vertices
{
    return mVertices;
}


- (PBMesh *)textureMesh
{
    return mTextureMesh;
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
        [self setupMesh];
    }
}


@end
