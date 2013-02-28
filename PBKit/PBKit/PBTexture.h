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


extern NSString *const kPBTextureLoadedKey;


@interface PBTexture : NSObject


@property (nonatomic, readonly, getter = isLoaded) BOOL      loaded;
@property (nonatomic, assign)                      NSInteger retryCount;


- (id)initWithImageName:(NSString *)aImageName;
- (id)initWithPath:(NSString *)aPath;
- (id)initWithImage:(UIImage *)aImage;
- (id)initWithImageSize:(CGSize)aSize scale:(CGFloat)aScale;

- (CGSize)size;
- (void)setSize:(CGSize)aSize;

- (void)loadIfNeeded;


#pragma mark -


- (GLuint)handle;
- (CGSize)imageSize;
- (void)setImageSize:(CGSize)aImageSize;
- (CGFloat)imageScale;


@end
