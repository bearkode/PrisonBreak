/*
 *  BendingProgram.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 4..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBKit.h>
#import "BendingProgram.h"


typedef struct {
    GLint projectionLoc;
    GLint positionLoc;
    GLint texCoordLoc;
    GLint timeLoc;
} BendingLocation;


@implementation BendingProgram
{
    BendingLocation mLocation;
    GLfloat         mBendingTime;
}


#pragma mark -


- (void)bindLocation
{
    mLocation.positionLoc   = [self attributeLocation:@"aPosition"];
    mLocation.texCoordLoc   = [self attributeLocation:@"aTexCoord"];
    mLocation.projectionLoc = [self uniformLocation:@"aProjection"];
    mLocation.timeLoc       = [self uniformLocation:@"uBendingTime"];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        [self setType:kPBProgramCustom];
        [self setDelegate:self];
        [self linkVertexShaderFilename:@"Bending" fragmentShaderFilename:@"Bending"];
        [self bindLocation];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)updateBendingTime
{
    mBendingTime += 0.03;
}


#pragma mark - PBProgramDelegate


- (void)pbProgramCustomDraw:(PBProgram *)aProgram
                        mvp:(PBMatrix)aProjection
                   vertices:(GLfloat *)aVertices
                 coordinate:(GLfloat *)aCoordinate
{
    glUniformMatrix4fv(mLocation.projectionLoc, 1, 0, &aProjection.m[0]);
    
    glUniform1f(mLocation.timeLoc, mBendingTime);
    
    glVertexAttribPointer(mLocation.positionLoc, 3, GL_FLOAT, GL_FALSE, 0, aVertices);
    glEnableVertexAttribArray(mLocation.positionLoc);
    glVertexAttribPointer(mLocation.texCoordLoc, 2, GL_FLOAT, GL_FALSE, 0, aCoordinate);
    glEnableVertexAttribArray(mLocation.texCoordLoc);

    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDisableVertexAttribArray(mLocation.positionLoc);
    glDisableVertexAttribArray(mLocation.texCoordLoc);
}


@end