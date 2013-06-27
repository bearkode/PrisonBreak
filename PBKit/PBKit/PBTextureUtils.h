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


#pragma mark - IMAGE


static inline CGSize PBImageSizeFromCGImage(CGImageRef aImage)
{
    return CGSizeMake(CGImageGetWidth(aImage), CGImageGetHeight(aImage));
}


GLubyte *PBImageDataCreate(CGImageRef aImage);


static inline void PBImageDataRelease(GLubyte *aData)
{
    if (aData)
    {
        free(aData);
    }
}


#pragma mark - TEXTURE


GLuint PBTextureCreate();
void PBTextureLoad(GLuint aHandle, CGSize aSize, GLubyte *aData);
void PBTextureRelease(GLuint aHandle);
