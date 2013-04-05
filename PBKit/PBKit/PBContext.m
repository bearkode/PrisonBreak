/*
 *  PBContext.m
 *  PBKit
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


#import "PBKit.h"


@implementation PBContext


#pragma mark -


+ (EAGLContext *)context
{
    static EAGLContext     *sContext;
    static dispatch_once_t  sOnce;
    
    dispatch_once(&sOnce, ^{
        sContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    });
    
    return sContext;
}


+ (void)performBlock:(void (^)(void))aBlock
{
    @synchronized(self)
    {
        [EAGLContext setCurrentContext:[self context]];

        aBlock();
        glFlush();
    }
}


+ (BOOL)performBlockOnMainThread:(void (^)(void))aBlock
{
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground)
    {
        if ([NSThread isMainThread])
        {
            [EAGLContext setCurrentContext:[self context]];
            
            aBlock();
            glFlush();
            
            return YES;
        }
        else
        {
            __block BOOL sResult = NO;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                sResult = [self performBlockOnMainThread:aBlock];
            });
            
            return sResult;
        }
    }
    else
    {
        return NO;
    }
}


@end
