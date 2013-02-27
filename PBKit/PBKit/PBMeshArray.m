/*
 *  PBMeshArray.m
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 27..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBMeshArray.h"
#import "PBException.h"
#import "PBTexture.h"
#import "PBProgram.h"


@implementation PBMeshArray
{
    GLuint mVertexArrayIndex;
}


@synthesize vertexArrayIndex = mVertexArrayIndex;


#pragma mark -


+ (BOOL)isValidVertexArrayIndex:(GLuint)aVertexArrayIndex
{
    return (aVertexArrayIndex == 0) ? NO : YES;
}


#pragma mark -


- (GLuint)makeVertexArrayWithMesh:(PBMesh *)aMesh program:(PBProgram *)aProgram
{
    GLuint sVertexBuffer;
    GLuint sIndexBuffer;
    
    PBGLErrorCheckBegin();
    
    glGenVertexArraysOES(1, &mVertexArrayIndex);
    glBindVertexArrayOES(mVertexArrayIndex);
    
    glGenBuffers(1, &sVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, sVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(PBMeshData) * sizeof([aMesh mesh]), [aMesh mesh], GL_STATIC_DRAW);
    
    glGenBuffers(1, &sIndexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, sIndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(gIndices), gIndices, GL_STATIC_DRAW);
    
    glVertexAttribPointer([aProgram location].positionLoc, 2, GL_FLOAT, GL_FALSE, sizeof(PBMeshData), 0);
    glVertexAttribPointer([aProgram location].texCoordLoc, 2, GL_FLOAT, GL_FALSE, sizeof(PBMeshData), (GLvoid*) (sizeof(float) * 2));
    
    glEnableVertexAttribArray([aProgram location].positionLoc);
    glEnableVertexAttribArray([aProgram location].texCoordLoc);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArrayOES(0);
    
    PBGLErrorCheckEnd();
    
    return mVertexArrayIndex;
}


@end
