/*
 *  PBContext.m
 *  PBKit
 *
 *  Created by sshanks on 12. 12. 27..
 *  Copyright (c) 2012년 sshanks. All rights reserved.
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


@end
