/*
 *  PBTexture.h
 *  PBKit
 *
 *  Created by bearkode on 13. 1. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>


@interface PBTexture : NSObject
{
    GLuint  mHandle;
    CGSize  mImageSize;
    CGFloat mImageScale;
    CGSize  mSize;
}


@property (nonatomic, readonly)                    GLuint    handle;
@property (nonatomic, readonly, getter = isLoaded) BOOL      loaded;
@property (nonatomic, assign)                      NSInteger retryCount;
@property (nonatomic, assign)                      id        textureLoadDelegate;


- (id)initWithImageName:(NSString *)aImageName;
- (id)initWithPath:(NSString *)aPath;
- (id)initWithImage:(UIImage *)aImage;
- (id)initWithSize:(CGSize)aSize scale:(CGFloat)aScale;

#pragma mark -

- (void)loadIfNeeded;

- (CGSize)size;
- (CGSize)imageSize;
- (CGFloat)imageScale;


@end


@protocol PBTextureLoadingDelegate <NSObject>

- (void)textureDidLoad:(PBTexture *)aTexture;

@end