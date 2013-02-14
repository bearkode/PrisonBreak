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


@class PBTextureInfo;


@interface PBTexture : NSObject

+ (PBTexture *)textureWithImageName:(NSString *)aName;

- (id)initWithImageName:(NSString *)aImageName;
- (id)initWithPath:(NSString *)aPath;
- (id)initWithImage:(UIImage *)aImage;
- (id)initWithImageSize:(CGSize)aSize scale:(CGFloat)aScale;
- (id)initWithTextureInfo:(PBTextureInfo *)aTextureInfo;

- (CGSize)size;

- (id)load;
- (GLfloat *)vertices;


#pragma mark -


- (PBTextureInfo *)textureInfo;
- (GLuint)handle;
- (CGSize)imageSize;
- (CGFloat)imageScale;


@end
