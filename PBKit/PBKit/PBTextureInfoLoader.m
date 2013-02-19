/*
 *  PBTextureLoader.m
 *  PBKit
 *
 *  Created by bearkode on 13. 1. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTextureInfoLoader.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "PBTextureInfoLoadOperation.h"
#import "PBTextureInfo.h"


static NSString *const kOperationCountDidChangeKeyPath = @"operations";
static NSString *const kOperationDidFinishKeyPath      = @"isFinished";


@implementation PBTextureInfoLoader
{
    NSInteger         mTotalCount;
    NSOperationQueue *mLoadQueue;
    
    id                mDelegate;
}


@synthesize delegate = mDelegate;


#pragma mark -


- (void)setupQueue
{
    mLoadQueue = [[NSOperationQueue alloc] init];
    [mLoadQueue setMaxConcurrentOperationCount:2];
    [mLoadQueue setSuspended:YES];
    
    [mLoadQueue addObserver:self forKeyPath:kOperationCountDidChangeKeyPath options:0 context:NULL];
}


- (void)clearQueue
{
    [mLoadQueue removeObserver:self forKeyPath:kOperationCountDidChangeKeyPath];
    
    for (PBTextureInfoLoadOperation *sOperation in [mLoadQueue operations])
    {
        [sOperation removeObserver:self forKeyPath:kOperationDidFinishKeyPath];
    }
    
    [mLoadQueue cancelAllOperations];
    [mLoadQueue release];
    mLoadQueue = nil;
}


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self setupQueue];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [self clearQueue];

    [super dealloc];
}


#pragma mark -


- (void)setMaxConcurrentOperationCount:(NSInteger)aCount
{
    [mLoadQueue setMaxConcurrentOperationCount:aCount];
}


- (void)addTextureInfo:(PBTextureInfo *)aTextureInfo
{
    PBTextureInfoLoadOperation *sOperation = [PBTextureInfoLoadOperation operationWithTextureInfo:aTextureInfo];

    [sOperation addObserver:self forKeyPath:kOperationDidFinishKeyPath options:0 context:NULL];
    [mLoadQueue addOperation:sOperation];
}


- (void)load
{
    mTotalCount = [mLoadQueue operationCount];
    
    if ([mDelegate respondsToSelector:@selector(textureInfoLoaderWillStartLoad:)])
    {
        [mDelegate textureInfoLoaderWillStartLoad:self];
    }
    
    [mLoadQueue setSuspended:NO];
}


- (void)cancel
{
    [self clearQueue];
    
    if ([mDelegate respondsToSelector:@selector(textureInfoLoaderDidCancelLoad:)])
    {
        [mDelegate textureInfoLoaderDidCancelLoad:self];
    }
}


- (BOOL)isSuspended
{
    return [mLoadQueue isSuspended];
}


- (void)setSuspended:(BOOL)aSuspended
{
    [mLoadQueue setSuspended:aSuspended];
}


#pragma mark -


- (void)operationCountDidChange
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([mDelegate respondsToSelector:@selector(textureInfoLoader:progress:)])
        {
            CGFloat sProgress = (CGFloat)(mTotalCount - [mLoadQueue operationCount]) / mTotalCount;
            [mDelegate textureInfoLoader:self progress:sProgress];
        }
        
        if ([mLoadQueue operationCount] == 0)
        {
            if ([mDelegate respondsToSelector:@selector(textureInfoLoaderDidFinishLoad:)])
            {
                [mDelegate textureInfoLoaderDidFinishLoad:self];
            }
        }
    });
}


- (void)operationDidFinish:(PBTextureInfoLoadOperation *)aOperation
{
    [aOperation removeObserver:self forKeyPath:kOperationDidFinishKeyPath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PBTextureInfo *sTextureInfo = [aOperation textureInfo];
        
        if ([sTextureInfo handle])
        {
            if ([mDelegate respondsToSelector:@selector(textureInfoLoader:didFinishLoadTextureInfo:)])
            {
                [mDelegate textureInfoLoader:self didFinishLoadTextureInfo:sTextureInfo];
            }
        }
        else
        {
            if ([sTextureInfo retryCount] < 3)
            {
                [sTextureInfo setRetryCount:[sTextureInfo retryCount] + 1];
                [self addTextureInfo:sTextureInfo];
            }
            else
            {
                if ([mDelegate respondsToSelector:@selector(textureInfoLoader:didFailLoadTextureInfo:)])
                {
                    [mDelegate textureInfoLoader:self didFailLoadTextureInfo:sTextureInfo];
                }
            }
        }
    });
}


- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)aObject change:(NSDictionary *)aChange context:(void *)aContext
{
    if ([aKeyPath isEqualToString:kOperationCountDidChangeKeyPath] && aObject == mLoadQueue)
    {
        [self operationCountDidChange];
    }
    else if ([aKeyPath isEqualToString:kOperationDidFinishKeyPath] && [aObject isKindOfClass:[PBTextureInfoLoadOperation class]])
    {
        [self operationDidFinish:(PBTextureInfoLoadOperation *)aObject];
    }
}


#pragma mark -


- (void)applicationDidEnterBackground:(NSNotification *)aNotification
{
    [mLoadQueue setSuspended:YES];
}


- (void)applicationWillEnterForeground:(NSNotification *)aNotification
{
    [mLoadQueue setSuspended:NO];
}


@end
