/*
 *  PBResource.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>


typedef enum
{
    kPBGLObjectUnknown = 0,
    kPBGLObjectShaderType,
    kPBGLObjectProgramType,
    kPBGLObjectRenderbufferType,
    kPBGLObjectFramebufferType,
    kPBGLObjectTextureType
} PBGLObjectType;


@interface PBResource : NSObject

@property (nonatomic, readonly) PBGLObjectType type;
@property (nonatomic, readonly) GLuint         handle;

+ (id)resourceWithType:(PBGLObjectType)aType handle:(GLuint)aHandle;

- (id)initWithType:(PBGLObjectType)aType handle:(GLuint)aHandle;

@end
