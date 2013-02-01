/*
 *  PBTextureUtils.m
 *  PBKit
 *
 *  Created by cgkim on 13. 1. 28..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#import "PBTextureUtils.h"


#define PVR_TEXTURE_FLAG_TYPE_MASK  0xff


static char gPVRTexIdentifier[4] = "PVR!";


enum
{
    kPBPVRTextureFlagTypePVRTC_2 = 24,
    kPBPVRTextureFlagTypePVRTC_4
};


typedef struct
{
    uint32_t headerLength;
    uint32_t height;
    uint32_t width;
    uint32_t numMipmaps;
    uint32_t flags;
    uint32_t dataLength;
    uint32_t bpp;
    uint32_t bitmaskRed;
    uint32_t bitmaskGreen;
    uint32_t bitmaskBlue;
    uint32_t bitmaskAlpha;
    uint32_t pvrTag;
    uint32_t numSurfs;
} PVRTexHeader;


#pragma mark -


GLubyte *PBCreateImageDataFromCGImage(CGImageRef aImage)
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


void PBImageDataRelease(GLubyte *aData)
{
    if (aData)
    {
        free(aData);
    }
}


CGSize PBImageSizeFromCGImage(CGImageRef aImage)
{
    return CGSizeMake(CGImageGetWidth(aImage), CGImageGetHeight(aImage));
}


#pragma mark -


GLuint PBCreateTexture(CGSize aSize, GLubyte *aData)
{
    if ([NSThread isMainThread])
    {
        GLuint sTextureID;
        
        glGenTextures(1, &sTextureID);
        glBindTexture(GL_TEXTURE_2D, sTextureID);
        
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, aSize.width, aSize.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, aData);
        glGenerateMipmap(GL_TEXTURE_2D);
        
        return sTextureID;
    }
    else
    {
        __block GLuint sTextureID = 0;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            sTextureID = PBCreateTexture(aSize, aData);
        });
        
        return sTextureID;
    }
}


GLuint PBCreateTextureWithPVRUnpackResult(PBPVRUnpackResult *aResult)
{
    if ([NSThread isMainThread])
    {
        GLuint          sTextureID = 0;
        NSMutableArray *sImageData = [aResult imageData];
        uint32_t        sWidth     = [aResult width];
        uint32_t        sHeight    = [aResult height];
        
        if ([aResult isSuccess])
        {
            NSData *sData;
            GLenum  sErr;
            
            if ([sImageData count] > 0)
            {
                glGenTextures(1, &sTextureID);
                glBindTexture(GL_TEXTURE_2D, sTextureID);
            }
            
            if ([sImageData count] > 1)
            {
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
            }
            else
            {
                glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            }
            
            for (NSInteger i = 0; i < [sImageData count]; i++)
            {
                sData = [sImageData objectAtIndex:i];
                glCompressedTexImage2D(GL_TEXTURE_2D, i, [aResult internalFormat], sWidth, sHeight, 0, [sData length], [sData bytes]);
                
                sErr = glGetError();
                if (sErr != GL_NO_ERROR)
                {
                    NSLog(@"Error uploading compressed texture level: %d. glError: 0x%04X", i, sErr);
                    return FALSE;
                }
                
                sWidth  = MAX(sWidth >> 1, 1);
                sHeight = MAX(sHeight >> 1, 1);
            }
        }
        
        return sTextureID;
    }
    else
    {
        __block GLuint sTextureID = 0;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            sTextureID = PBCreateTextureWithPVRUnpackResult(aResult);
        });
        
        return sTextureID;
    }
}


void PBTextureRelease(GLuint aTextureID)
{
    if ([NSThread isMainThread])
    {
        glDeleteTextures(1, &aTextureID);
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            PBTextureRelease(aTextureID);
        });
    }
}


#pragma mark -


BOOL PBIsPVRFile(NSString *aPath)
{
    NSString *aExtension = [aPath pathExtension];
    
    if ([[aExtension lowercaseString] isEqualToString:@"pvr"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


PBPVRUnpackResult *PBUnpackPVRData(NSData *aData)
{
    PBPVRUnpackResult *sResult = [[[PBPVRUnpackResult alloc] init] autorelease];
    PVRTexHeader      *sHeader  = NULL;
    uint32_t           sFlags;
    uint32_t           sPvrTag;
    uint32_t           sDataLength   = 0;
    uint32_t           sDataOffset   = 0;
    uint32_t           sDataSize     = 0;
    uint32_t           sBlockSize    = 0;
    uint32_t           sWidthBlocks  = 0;
    uint32_t           sHeightBlocks = 0;
    uint32_t           sWidth        = 0;
    uint32_t           sHeight       = 0;
    uint32_t           sBPP          = 4;
    uint8_t           *sBytes        = NULL;
    uint32_t           sFormatFlags;
    
    sHeader = (PVRTexHeader *)[aData bytes];
    
    sPvrTag = CFSwapInt32LittleToHost(sHeader->pvrTag);
    
    if (gPVRTexIdentifier[0] != ((sPvrTag >>  0) & 0xff) ||
        gPVRTexIdentifier[1] != ((sPvrTag >>  8) & 0xff) ||
        gPVRTexIdentifier[2] != ((sPvrTag >> 16) & 0xff) ||
        gPVRTexIdentifier[3] != ((sPvrTag >> 24) & 0xff))
    {
        return sResult;
    }
    
    sFlags = CFSwapInt32LittleToHost(sHeader->flags);
    sFormatFlags = sFlags & PVR_TEXTURE_FLAG_TYPE_MASK;
    
    if (sFormatFlags == kPBPVRTextureFlagTypePVRTC_4 || sFormatFlags == kPBPVRTextureFlagTypePVRTC_2)
    {
        if (sFormatFlags == kPBPVRTextureFlagTypePVRTC_4)
        {
            [sResult setInternalFormat:GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG];
        }
        else if (sFormatFlags == kPBPVRTextureFlagTypePVRTC_2)
        {
            [sResult setInternalFormat:GL_COMPRESSED_RGBA_PVRTC_2BPPV1_IMG];
        }
        
        sWidth  = CFSwapInt32LittleToHost(sHeader->width);
        sHeight = CFSwapInt32LittleToHost(sHeader->height);
        
        [sResult setWidth:sWidth];
        [sResult setHeight:sHeight];
        [sResult setHasAlpha:CFSwapInt32LittleToHost(sHeader->bitmaskAlpha)];
        
        sDataLength = CFSwapInt32LittleToHost(sHeader->dataLength);
        
        sBytes = ((uint8_t *)[aData bytes]) + sizeof(PVRTexHeader);
        
        /*  Calculate the data size for each texture level and respect the minimum number of blocks  */
        while (sDataOffset < sDataLength)
        {
            if (sFormatFlags == kPBPVRTextureFlagTypePVRTC_4)
            {
                sBlockSize    = 4 * 4;      /*  Pixel by pixel block size for 4bpp  */
                sWidthBlocks  = sWidth / 4;
                sHeightBlocks = sHeight / 4;
                sBPP          = 4;
            }
            else
            {
                sBlockSize    = 8 * 4;      /*  Pixel by pixel block size for 2bpp  */
                sWidthBlocks  = sWidth / 8;
                sHeightBlocks = sHeight / 4;
                sBPP          = 2;
            }
            
            /*  Clamp to minimum number of blocks  */
            if (sWidthBlocks < 2)
            {
                sWidthBlocks = 2;
            }
            
            if (sHeightBlocks < 2)
            {
                sHeightBlocks = 2;
            }
            
            sDataSize = sWidthBlocks * sHeightBlocks * ((sBlockSize  * sBPP) / 8);
            
            [[sResult imageData] addObject:[NSData dataWithBytes:sBytes + sDataOffset length:sDataSize]];
            
            sDataOffset += sDataSize;
            
            sWidth  = MAX(sWidth >> 1, 1);
            sHeight = MAX(sHeight >> 1, 1);
        }
        
        [sResult setIsSuccess:YES];
    }
    
    return sResult;
}
