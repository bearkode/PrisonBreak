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
    GLuint  mTextureID;

    CGSize  mImageSize;
    CGSize  mSize;
    GLfloat mVertices[8];
}

@property (nonatomic, readonly) GLuint  textureID;
@property (nonatomic, readonly) CGSize  imageSize;
@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, readonly) CGFloat imageScale;

+ (PBTexture *)textureNamed:(NSString *)aName;

- (id)initWithImageName:(NSString *)aImageName;
- (id)initWithPath:(NSString *)aPath;
- (id)initWithImage:(UIImage *)aImage;

- (id)initWithImageName:(NSString *)aImageName scale:(CGFloat)aScale;

- (id)load;

- (CGSize)size;

- (void)setVertices:(GLfloat *)aVertices;
- (GLfloat *)vertices;

@end
