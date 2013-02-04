/*
 *  PBTexture.h
 *  PBKit
 *
 *  Created by cgkim on 13. 1. 25..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>


@interface PBTexture : NSObject

@property (nonatomic, readonly) GLuint textureID;
@property (nonatomic, readonly) CGSize size;

+ (PBTexture *)textureNamed:(NSString *)aName;

- (id)initWithImageName:(NSString *)aImageName;
- (id)initWithPath:(NSString *)aPath;
- (id)initWithImage:(UIImage *)aImage;
- (id)load;

- (void)setTileSize:(CGSize)aTileSize;
- (CGSize)tileSize;

- (void)setVertices:(GLfloat *)aVertices;
- (GLfloat *)vertices;

@end
