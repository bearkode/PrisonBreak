/*
 *  PBResourceManager.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface PBResourceManager : NSObject

+ (id)sharedManager;

- (void)removeFramebuffer:(GLuint)aHandle;
- (void)removeRenderbuffer:(GLuint)aHandle;
- (void)removeTexture:(GLuint)aHandle;

@end
