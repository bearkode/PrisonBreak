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

    CGSize  mSize;
    GLfloat mVertices[8];
    CGSize  mTileSize;
}

@property (nonatomic, readonly) GLuint textureID;

+ (PBTexture *)textureNamed:(NSString *)aName;

- (id)initWithImageName:(NSString *)aImageName;
- (id)initWithPath:(NSString *)aPath;
- (id)initWithImage:(UIImage *)aImage;
- (id)load;

- (CGSize)size;
- (void)setTileSize:(CGSize)aTileSize;
- (CGSize)tileSize;

- (void)setVertices:(GLfloat *)aVertices;
- (GLfloat *)vertices;

@end
