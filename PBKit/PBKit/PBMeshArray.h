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
#import "PBMesh.h"


@class PBProgram;
@class PBTexture;


@interface PBMeshArray : NSObject


@property (nonatomic, readonly) GLuint vertexArrayIndex;


#pragma mark -


+ (BOOL)isValidVertexArrayIndex:(GLuint)aVertexArrayIndex;


#pragma mark -


- (GLuint)makeVertexArrayWithMesh:(PBMesh *)aMesh program:(PBProgram *)aProgram;


@end
