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
    BOOL            mIsSuccess;
    NSMutableArray *mImageData;
    uint32_t        mWidth;
    uint32_t        mHeight;
    GLenum          mInternalFormat;
    BOOL            mHasAlpha;
}

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
        mIsSuccess = NO;
        mImageData = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    return self;
}


- (void)dealloc
{
    [mImageData release];
    
    [super dealloc];
}


@end
