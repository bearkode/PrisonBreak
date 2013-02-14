/*
 *  PBTextureInfo.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 13..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>


extern NSString *const kPBTextureInfoLoadedKey;


@interface PBTextureInfo : NSObject

@property (nonatomic, readonly)                    GLuint  handle;
@property (nonatomic, readonly)                    CGSize  imageSize;
@property (nonatomic, readonly)                    CGFloat imageScale;
@property (nonatomic, readonly, getter = isLoaded) BOOL    loaded;

- (id)initWithImageName:(NSString *)aImageName;
- (id)initWithPath:(NSString *)aPath scale:(CGFloat)aScale;
- (id)initWithImage:(UIImage *)aImage;
- (id)initWithSize:(CGSize)aSize scale:(CGFloat)aScale;

- (void)loadIfNeeded;

- (void)setImageSize:(CGSize)aImageSize;

@end
