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


#pragma mark - PVR


BOOL PBIsPVRFile(NSString *aPath);
PBPVRUnpackResult *PBUnpackPVRData(NSData *aData);


#pragma mark - TEXTURE


GLuint PBTextureCreate();
GLuint PBPVRTextureCreate(PBPVRUnpackResult *aResult);
void PBTextureLoad(GLuint aHandle, CGSize aSize, GLubyte *aData);
void PBTextureRelease(GLuint aTextureID);
