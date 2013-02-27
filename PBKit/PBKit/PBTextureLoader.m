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
#import "PBTextureLoadOperation.h"
#import "PBTexture.h"


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
    
    for (PBTextureLoadOperation *sOperation in [mLoadQueue operations])
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


- (void)addTexture:(PBTexture *)aTexture
{
    PBTextureLoadOperation *sOperation = [PBTextureLoadOperation operationWithTexture:aTexture];

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
    
    [mLoadQueue setSuspended:NO];
}


- (void)cancel
{
    [self clearQueue];
    
    if ([mDelegate respondsToSelector:@selector(textureLoaderDidCancelLoad:)])
    {
        [mDelegate textureLoaderDidCancelLoad:self];
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


- (void)operationDidFinish:(PBTextureLoadOperation *)aOperation
{
    [aOperation removeObserver:self forKeyPath:kOperationDidFinishKeyPath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PBTexture *sTexture = [aOperation texture];
        
        if ([sTexture handle])
        {
            if ([mDelegate respondsToSelector:@selector(textureLoader:didFinishLoadTexture:)])
            {
                [mDelegate textureLoader:self didFinishLoadTexture:sTexture];
            }
        }
        else
        {
            if ([sTexture retryCount] < 3)
            {
                [sTexture setRetryCount:[sTexture retryCount] + 1];
                [self addTexture:sTexture];
            }
            else
            {
                if ([mDelegate respondsToSelector:@selector(textureInfoLoader:didFailLoadTexture:)])
                {
                    [mDelegate textureLoader:self didFailLoadTexture:sTexture];
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
    else if ([aKeyPath isEqualToString:kOperationDidFinishKeyPath] && [aObject isKindOfClass:[PBTextureLoadOperation class]])
    {
        [self operationDidFinish:(PBTextureLoadOperation *)aObject];
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
