/*
 *  PBTextureUtils.m
 *  PBKit
 *
 *  Created by bearkode on 13. 1. 28..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "PBTextureUtils.h"
#import "PBContext.h"
#import "PBException.h"


#pragma mark - IMAGE


GLubyte *PBImageDataCreate(CGImageRef aImage)
{
    GLubyte        *sData       = nil;
    CGSize          sSize       = CGSizeZero;
    CGColorSpaceRef sColorSpace = 0;
    CGContextRef    sContext    = 0;
    
    if (aImage)
    {
        sSize = CGSizeMake(CGImageGetWidth(aImage), CGImageGetHeight(aImage));
        sData = (GLubyte *)calloc(sSize.width * sSize.height * 4, sizeof(GLubyte));
        
        if (sData)
        {
            sColorSpace = CGImageGetColorSpace(aImage);
            sContext    = CGBitmapContextCreate(sData, sSize.width, sSize.height, 8, sSize.width * 4, sColorSpace, kCGImageAlphaPremultipliedLast);
            CGContextDrawImage(sContext, CGRectMake(0, 0, sSize.width, sSize.height), aImage);
            CGContextRelease(sContext);
        }
    }
    
    return sData;
}


#pragma mark - TEXTURE


GLuint PBTextureCreate()
{
    __block GLuint sHandle = 0;
    
    [PBContext performBlockOnMainThread:^{
        glGenTextures(1, &sHandle);
        glBindTexture(GL_TEXTURE_2D, sHandle);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    }];
    
    return sHandle;
}


void PBTextureLoad(GLuint aHandle, CGSize aSize, GLubyte *aData)
{
    [PBContext performBlockOnMainThread:^{
        glBindTexture(GL_TEXTURE_2D, aHandle);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)aSize.width, (GLsizei)aSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, aData);
    }];
}


void PBTextureRelease(GLuint aHandle)
{
    [PBContext performBlockOnMainThread:^{
        if (aHandle)
        {
            glDeleteTextures(1, &aHandle);
        }
    }];
}
