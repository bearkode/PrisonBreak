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
#import "PBMesh.h"
#import "PBTexture.h"
#import "PBProgram.h"
#import "PBGLObjectManager.h"


@implementation PBMeshArray
{
    GLuint mVertexArray;
    GLuint mVertexBuffer;
    GLuint mIndexBuffer;
}


@synthesize vertexArray = mVertexArray;


#pragma mark


- (void)setupWithMesh:(PBMesh *)aMesh
{
    PBGLErrorCheckBegin();
    
    glGenVertexArraysOES(1, &mVertexArray);
    glBindVertexArrayOES(mVertexArray);
    
    glGenBuffers(1, &mVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, mVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(PBMeshData) * sizeof([aMesh meshData]), [aMesh meshData], GL_STATIC_DRAW);
    
    glGenBuffers(1, &mIndexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, mIndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(gIndices), gIndices, GL_STATIC_DRAW);
    
    glVertexAttribPointer([[aMesh program] location].positionLoc, 2, GL_FLOAT, GL_FALSE, sizeof(PBMeshData), 0);
    glVertexAttribPointer([[aMesh program] location].texCoordLoc, 2, GL_FLOAT, GL_FALSE, sizeof(PBMeshData), (GLvoid*) (sizeof(float) * 2));
    
    glEnableVertexAttribArray([[aMesh program] location].positionLoc);
    glEnableVertexAttribArray([[aMesh program] location].texCoordLoc);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArrayOES(0);
    
    PBGLErrorCheckEnd();
}


- (void)cleanup
{
    [[PBGLObjectManager sharedManager] deleteVertexArray:mVertexArray];
    [[PBGLObjectManager sharedManager] deleteBuffer:mVertexBuffer];
    [[PBGLObjectManager sharedManager] deleteBuffer:mIndexBuffer];
    
    mVertexArray  = 0;
    mVertexBuffer = 0;
    mIndexBuffer  = 0;
}


#pragma mark -


- (id)initWithMesh:(PBMesh *)aMesh
{
    self = [super init];
    
    if (self)
    {
        [self setupWithMesh:aMesh];
        
    }
    
    return self;
}


- (void)dealloc
{
    [self cleanup];
    
    [super dealloc];
}



#pragma mark -


- (BOOL)validate
{
    return (mVertexArray) ? YES : NO;
}


@end
