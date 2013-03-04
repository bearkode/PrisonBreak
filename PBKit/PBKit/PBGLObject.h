/*
 *  PBGLObject.h
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
    kPBGLObjectTextureType,
    kPBGLObjectVertexArrayType,
    kPBGLObjectBufferType,
} PBGLObjectType;


@interface PBGLObject : NSObject

@property (nonatomic, readonly) PBGLObjectType type;
@property (nonatomic, readonly) GLuint         handle;

+ (id)objectWithType:(PBGLObjectType)aType handle:(GLuint)aHandle;

- (id)initWithType:(PBGLObjectType)aType handle:(GLuint)aHandle;

@end
