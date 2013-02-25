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

- (void)removeShader:(GLuint)aHandle;
- (void)removeProgram:(GLuint)aHandle;
- (void)removeFramebuffer:(GLuint)aHandle;
- (void)removeRenderbuffer:(GLuint)aHandle;
- (void)removeTexture:(GLuint)aHandle;

@end
