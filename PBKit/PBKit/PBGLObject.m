/*
 *  PBGLObject.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBGLObject.h"


@implementation PBGLObject
{
    PBGLObjectType mType;
    GLuint         mHandle;
}


@synthesize type   = mType;
@synthesize handle = mHandle;


+ (id)objectWithType:(PBGLObjectType)aType handle:(GLuint)aHandle
{
    return [[[PBGLObject alloc] initWithType:aType handle:aHandle] autorelease];
}


- (id)initWithType:(PBGLObjectType)aType handle:(GLuint)aHandle
{
    self = [super init];
    
    if (self)
    {
        mType   = aType;
        mHandle = aHandle;
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


@end
