/*
 *  PBPVRUnpackResult.m
 *  PBKit
 *
 *  Created by cgkim on 13. 1. 25..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#import "PBPVRUnpackResult.h"


@implementation PBPVRUnpackResult
{
    BOOL            mSuccess;
    NSMutableArray *mImageData;
    uint32_t        mWidth;
    uint32_t        mHeight;
    GLenum          mInternalFormat;
    BOOL            mHasAlpha;
}

@synthesize success        = mSuccess;
@synthesize imageData      = mImageData;
@synthesize width          = mWidth;
@synthesize height         = mHeight;
@synthesize internalFormat = mInternalFormat;
@synthesize hasAlpha       = mHasAlpha;


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mSuccess        = NO;
        mImageData      = [[NSMutableArray alloc] initWithCapacity:10];
        mInternalFormat = GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG;
    }
    
    return self;
}


- (void)dealloc
{
    [mImageData release];
    
    [super dealloc];
}


@end
