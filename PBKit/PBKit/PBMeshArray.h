/*
 *  PBMeshArray.h
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 27..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>


@class PBMesh;
@class PBProgram;
@class PBTexture;


@interface PBMeshArray : NSObject


@property (nonatomic, readonly) GLuint vertexArrayIndex;


#pragma mark -


- (id)initWithMesh:(PBMesh *)aMesh;
- (BOOL)validate;


@end
