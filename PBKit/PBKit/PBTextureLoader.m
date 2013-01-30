/*
 *  PBTextureLoader.m
 *  PBKit
 *
 *  Created by bearkode on 13. 1. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTextureLoader.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "PBTexture.h"
#import "PBTextureLoadOperation.h"


static NSString *const kOperationCountDidChangeKeyPath = @"operations";
static NSString *const kOperationDidFinishKeyPath      = @"isFinished";


@implementation PBTextureLoader
{
    NSInteger         mTotalCount;
    NSOperationQueue *mLoadQueue;
    
    id                mDelegate;
}


@synthesize delegate = mDelegate;


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mLoadQueue = [[NSOperationQueue alloc] init];
        [mLoadQueue setMaxConcurrentOperationCount:2];
        [mLoadQueue setSuspended:YES];
    }
    
    return self;
}


- (void)dealloc
{
    [mLoadQueue release];
    
    [super dealloc];
}


#pragma mark -


- (void)setMaxConcurrentOperationCount:(NSInteger)aCount
{
    [mLoadQueue setMaxConcurrentOperationCount:aCount];
}


- (void)addTexture:(PBTexture *)aTexture
{
    PBTextureLoadOperation *sOperation = [PBTextureLoadOperation textureLoadOperationWithTexture:aTexture];

    [sOperation addObserver:self forKeyPath:kOperationDidFinishKeyPath options:0 context:NULL];
    [mLoadQueue addOperation:sOperation];
}


- (void)load
{
    mTotalCount = [mLoadQueue operationCount];
    
    if ([mDelegate respondsToSelector:@selector(textureLoaderWillStartLoad:)])
    {
        [mDelegate textureLoaderWillStartLoad:self];
    }
    
    [mLoadQueue addObserver:self forKeyPath:kOperationCountDidChangeKeyPath options:0 context:NULL];
    [mLoadQueue setSuspended:NO];
}


#pragma mark -


- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)aObject change:(NSDictionary *)aChange context:(void *)aContext
{
    if ([aKeyPath isEqualToString:kOperationCountDidChangeKeyPath] && aObject == mLoadQueue)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([mDelegate respondsToSelector:@selector(textureLoader:progress:)])
            {
                CGFloat sProgress = (CGFloat)(mTotalCount - [mLoadQueue operationCount]) / mTotalCount;
                [mDelegate textureLoader:self progress:sProgress];
            }

            if ([mLoadQueue operationCount] == 0)
            {
                if ([mDelegate respondsToSelector:@selector(textureLoaderDidFinishLoad:)])
                {
                    [mDelegate textureLoaderDidFinishLoad:self];
                }
            }
        });
    }
    else if ([aKeyPath isEqualToString:kOperationDidFinishKeyPath] && [aObject isKindOfClass:[PBTextureLoadOperation class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            PBTextureLoadOperation *sOperation = (PBTextureLoadOperation *)aObject;
            PBTexture              *sTexture   = [sOperation texture];
            
            if ([mDelegate respondsToSelector:@selector(textureLoader:didFinishLoadTexture:)])
            {
                [mDelegate textureLoader:self didFinishLoadTexture:sTexture];
            }
        });
    }
}


@end
