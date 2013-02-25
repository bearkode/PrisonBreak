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
#import "PBResource.h"
#import "PBObjCUtil.h"
#import "PBTextureUtils.h"


@implementation PBResourceManager
{
    NSMutableArray *mHandles;
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
        
        mHandles = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [mHandles release];

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
        
        for (PBResource *sResource in mHandles)
        {
            if ([sResource type] == kPBGLObjectTextureType)
            {
                [self removeTexture:[sResource handle]];
            }
            else if ([sResource type] == kPBGLObjectFramebufferType)
            {
                [self removeFramebuffer:[sResource handle]];
            }
            else if ([sResource type] == kPBGLObjectRenderbufferType)
            {
                [self removeRenderbuffer:[sResource handle]];
            }
            else if ([sResource type] == kPBGLObjectProgramType)
            {
                [self removeProgram:[sResource handle]];
            }
            else if ([sResource type] == kPBGLObjectShaderType)
            {
                [self removeShader:[sResource handle]];
            }
        }
        [mHandles removeAllObjects];
    });
}


#pragma mark -


- (BOOL)isActive
{
    return ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive);
}


- (void)removeShader:(GLuint)aHandle
{
    if (aHandle)
    {
        if ([self isActive])
        {
            glDeleteShader(aHandle);
        }
        else
        {
            PBResource *sResource = [PBResource resourceWithType:kPBGLObjectShaderType handle:aHandle];
            [mHandles addObject:sResource];
        }
    }
}


- (void)removeProgram:(GLuint)aHandle
{
    if (aHandle)
    {
        if ([self isActive])
        {
            glDeleteProgram(aHandle);
        }
        else
        {
            [mHandles addObject:[PBResource resourceWithType:kPBGLObjectProgramType handle:aHandle]];
        }
    }
}


- (void)removeFramebuffer:(GLuint)aHandle
{
    if (aHandle)
    {
        if ([self isActive])
        {
            glDeleteFramebuffers(1, &aHandle);
        }
        else
        {
            [mHandles addObject:[PBResource resourceWithType:kPBGLObjectFramebufferType handle:aHandle]];
        }
    }
}


- (void)removeRenderbuffer:(GLuint)aHandle
{
    if (aHandle)
    {
        if ([self isActive])
        {
            glDeleteRenderbuffers(1, &aHandle);
        }
        else
        {
            [mHandles addObject:[PBResource resourceWithType:kPBGLObjectRenderbufferType handle:aHandle]];
        }
    }
}


- (void)removeTexture:(GLuint)aHandle
{
    if (aHandle)
    {
        if ([self isActive])
        {
            PBTextureRelease(aHandle);
        }
        else
        {
            [mHandles addObject:[PBResource resourceWithType:kPBGLObjectTextureType handle:aHandle]];
        }
    }
}


@end
