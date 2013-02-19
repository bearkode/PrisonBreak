/*
 *  PBTextureInfoLoadOperation.m
 *  PBKit
 *
 *  Created by bearkode on 13. 1. 28..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTextureInfoLoadOperation.h"
#import "PBTextureUtils.h"
#import "PBTextureInfo.h"


@implementation PBTextureInfoLoadOperation
{
    NSInteger      mRetryCount;
    PBTextureInfo *mTextureInfo;
}


@synthesize textureInfo = mTextureInfo;


#pragma mark -


+ (id)operationWithTextureInfo:(PBTextureInfo *)aTextureInfo
{
    return [[[PBTextureInfoLoadOperation alloc] initWithTextureInfo:aTextureInfo] autorelease];
}


#pragma mark -


- (id)initWithTextureInfo:(PBTextureInfo *)aTextureInfo
{
    self = [super init];
    
    if (self)
    {
        mTextureInfo = [aTextureInfo retain];
    }
    
    return self;
}


- (void)dealloc
{
    [mTextureInfo release];
    
    [super dealloc];
}


#pragma mark -


- (void)main
{
    [mTextureInfo loadIfNeeded];
}


@end
