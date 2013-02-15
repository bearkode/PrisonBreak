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
#import "PBTextureInfoLoadOperation.h"


static NSString *const kOperationCountDidChangeKeyPath = @"operations";
static NSString *const kOperationDidFinishKeyPath      = @"isFinished";


@implementation PBTextureLoader
{
    NSInteger            mTotalCount;
    NSOperationQueue    *mLoadQueue;
    NSMutableDictionary *mTextureDict;
    
    id                   mDelegate;
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
        
        mTextureDict = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mLoadQueue release];
    [mTextureDict release];
    
    [super dealloc];
}


#pragma mark -


- (void)setMaxConcurrentOperationCount:(NSInteger)aCount
{
    [mLoadQueue setMaxConcurrentOperationCount:aCount];
}


- (void)addTexture:(PBTexture *)aTexture
{
    PBTextureInfoLoadOperation *sOperation = [PBTextureInfoLoadOperation operationWithTextureInfo:[aTexture textureInfo]];

    [sOperation addObserver:self forKeyPath:kOperationDidFinishKeyPath options:0 context:NULL];
    [mLoadQueue addOperation:sOperation];
    
    [mTextureDict setObject:aTexture forKey:[NSValue valueWithPointer:[aTexture textureInfo]]];
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
    else if ([aKeyPath isEqualToString:kOperationDidFinishKeyPath] && [aObject isKindOfClass:[PBTextureInfoLoadOperation class]])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            PBTextureInfoLoadOperation *sOperation   = (PBTextureInfoLoadOperation *)aObject;
            PBTextureInfo              *sTextureInfo = [sOperation textureInfo];
            NSValue                    *sKey         = [NSValue valueWithPointer:sTextureInfo];
            PBTexture                  *sTexture     = [mTextureDict objectForKey:sKey];
            
            if ([mDelegate respondsToSelector:@selector(textureLoader:didFinishLoadTexture:)])
            {
                [mDelegate textureLoader:self didFinishLoadTexture:sTexture];
            }
            
            [mTextureDict removeObjectForKey:sKey];
        });
    }
}


@end
