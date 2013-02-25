/*
 *  PBGLObjectManager.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "PBGLObjectManager.h"
#import "PBGLObject.h"
#import "PBObjCUtil.h"
#import "PBTextureUtils.h"


@implementation PBGLObjectManager
{
    NSMutableArray *mPendingObjects;
}


SYNTHESIZE_SHARED_INSTANCE(PBGLObjectManager, sharedManager);


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
        
        mPendingObjects = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [mPendingObjects release];

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
        
        for (PBGLObject *sObject in mPendingObjects)
        {
            [self removeObject:sObject];
        }
        [mPendingObjects removeAllObjects];
    });
}


#pragma mark -


- (BOOL)isActive
{
    return ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive);
}


- (void)removeObject:(PBGLObject *)aObject
{
    PBGLObjectType sType   = [aObject type];
    GLuint         sHandle = [aObject handle];
    
    if (sType == kPBGLObjectTextureType)
    {
        [self removeTexture:sHandle];
    }
    else if (sType == kPBGLObjectFramebufferType)
    {
        [self removeFramebuffer:sHandle];
    }
    else if (sType == kPBGLObjectRenderbufferType)
    {
        [self removeRenderbuffer:sHandle];
    }
    else if (sType == kPBGLObjectProgramType)
    {
        [self removeProgram:sHandle];
    }
    else if (sType == kPBGLObjectShaderType)
    {
        [self removeShader:sHandle];
    }
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
            [mPendingObjects addObject:[PBGLObject objectWithType:kPBGLObjectShaderType handle:aHandle]];
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
            [mPendingObjects addObject:[PBGLObject objectWithType:kPBGLObjectProgramType handle:aHandle]];
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
            [mPendingObjects addObject:[PBGLObject objectWithType:kPBGLObjectFramebufferType handle:aHandle]];
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
            [mPendingObjects addObject:[PBGLObject objectWithType:kPBGLObjectRenderbufferType handle:aHandle]];
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
            [mPendingObjects addObject:[PBGLObject objectWithType:kPBGLObjectTextureType handle:aHandle]];
        }
    }
}


@end
