/*
 *  PBTextureUtils.h
 *  PBKit
 *
 *  Created by bearkode on 13. 1. 28..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "PBPVRUnpackResult.h"


GLubyte *PBCreateImageDataFromCGImage(CGImageRef aImage);
void PBImageDataRelease(GLubyte *aData);
CGSize PBImageSizeFromCGImage(CGImageRef aImage);

GLuint PBCreateTexture(CGSize aSize, GLubyte *aData);
GLuint PBCreateEmptyTexture();
GLuint PBCreateTextureWithPVRUnpackResult(PBPVRUnpackResult *aResult);
void PBTextureRelease(GLuint aTextureID);

BOOL PBIsPVRFile(NSString *aPath);
PBPVRUnpackResult *PBUnpackPVRData(NSData *aData);
