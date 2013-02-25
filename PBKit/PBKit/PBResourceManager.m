/*
 *  PBResourceManager.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "PBResourceManager.h"
#import "PBObjCUtil.h"
#import "PBTextureUtils.h"


@implementation PBResourceManager
{
    NSMutableArray *mTextureHandles;
}


SYNTHESIZE_SHARED_INSTANCE(PBResourceManager, sharedManager);


+ (void)load
{
    [self sharedManager];
}


- (id)init
{
    self = [super init];
    
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        mTextureHandles = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];

    [super dealloc];
}


- (void)applicationDidEnterBackground:(NSNotification *)aNotification
{
    NSLog(@"applicationDidEnterBackground:");
}


- (void)applicationWillEnterForeground:(NSNotification *)aNotification
{
    NSLog(@"applicationWillEnterForeground:");

    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSNumber *sValue in mTextureHandles)
        {
            GLuint sHandle = [sValue integerValue];
            [self removeTexture:sHandle];
        }
    });
}


- (void)removeTexture:(GLuint)aHandle
{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        PBTextureRelease(aHandle);
    }
    else
    {
        NSNumber *sValue = [NSNumber numberWithInteger:aHandle];
        [mTextureHandles addObject:sValue];
    }
}


@end
