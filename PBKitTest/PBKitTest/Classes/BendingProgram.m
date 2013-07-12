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


@implementation BendingProgram
{
    GLint   mBendingTimeLoc;
    GLfloat mBendingTime;
}


#pragma mark -


- (void)bindLocation
{
    [self setPositionLocation:[self attributeLocation:@"aPosition"]];
    [self setProjectionLocation:[self uniformLocation:@"aProjection"]];
    [self setTexCoordLocation:[self attributeLocation:@"aTexCoord"]];
    mBendingTimeLoc = [self uniformLocation:@"uBendingTime"];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        [self setMode:kPBProgramModeSemiauto];
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


#pragma mark - PBProgramDrawDelegate


- (void)pbProgramWillSemiautoDraw:(PBProgram *)aProgram
{
    glUniform1f(mBendingTimeLoc, mBendingTime);
}


@end