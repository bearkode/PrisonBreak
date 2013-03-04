/*
 *  PBGLobjectManager.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface PBGLObjectManager : NSObject

+ (id)sharedManager;

- (void)deleteShader:(GLuint)aHandle;
- (void)deleteProgram:(GLuint)aHandle;
- (void)deleteFramebuffer:(GLuint)aHandle;
- (void)deleteRenderbuffer:(GLuint)aHandle;
- (void)deleteTexture:(GLuint)aHandle;
- (void)deleteVertexArray:(GLuint)aHandle;
- (void)deleteBuffer:(GLuint)aHandle;

@end
