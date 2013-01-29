/*
 *  PBPVRUnpackResult.h
 *  PBKit
 *
 *  Created by cgkim on 13. 1. 25..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

/*
 
 PNGs:
 
 - High precision color representation, not lossy
 - Slow decompression from disk.
 - Slow uploading to graphics hardware, internal pixel reordering is performed by drivers.
 - Slower rendering because of limited memory bandwidth. Actual amount of slowdown depends on usage scenario. This problem is mostly noticeable with lower than 1x magnification ratio and no MIP-mapping.
 - Take more RAM/VRAM space.
 - Editable, can be filtered/blended/resized/converted by your software before upload.
 - Mip-maps can be generated automatically during texture upload
 - Disk space usage varies with content, very small for simple images, almost uncompressed for photorealistic ones.
 - Can be exported from any image-editing software directly and quickly.
 
 PVRs:
 
 - Low precision lossy compression (2 levels ), blocky, no sharp edges and smooth gradients. Image quality varies with content. 2-bit and 4-bit compression methods are available, 3 or 4 color channels.
 - Fast loading from disk, no software decompression needed.
 - Almost instant texture upload, because it's an internal hardware format, will go through drivers unchanged.
 - fast rendering because of smaller memory bandwidth usage. Pixel rendering speed is mostly limited by other factors when PVR textures are used.
 - Take a little RAM/VRAM space.
 - Mip-maps must be pre-generated.
 - You can't generate or edit PVRs inside of your software AFAIK. Or it will very slow.
 - Disk space usage is directly proportional to image size. Can be further compressed by other methods.
 - Size limitations. Powers of 2, square only.
 - Additional conversion tool is required, process can be automated, but will slow down build times considerably.
 
 */


@interface PBPVRUnpackResult : NSObject

@property (nonatomic, assign)   BOOL            isSuccess;
@property (nonatomic, readonly) NSMutableArray *imageData;
@property (nonatomic, assign)   uint32_t        width;
@property (nonatomic, assign)   uint32_t        height;
@property (nonatomic, assign)   GLenum          internalFormat;
@property (nonatomic, assign)   BOOL            hasAlpha;

@end
