/*
 *  PBException.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 15..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


#define PBGLErrorCheckBegin()   glGetError()
#define PBGLErrorCheckEnd()     NSAssert(glGetError() == GL_NO_ERROR, nil)   


@interface PBException : NSObject

@end
