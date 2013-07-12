/*
 *  LightingProgram.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 11..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBKit.h>
#import "LightingProgram.h"


@implementation LightingProgram
{
}


#pragma mark -


- (void)bindLocation
{
//    [self setPositionLocation:[self attributeLocation:@"aPosition"]];
//    [self setProjectionLocation:[self uniformLocation:@"aProjection"]];
//    [self setTexCoordLocation:[self attributeLocation:@"aTexCoord"]];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        [self setMode:kPBProgramModeSemiauto];
        [self setDelegate:self];
        [self linkVertexShaderFilename:@"Lightning" fragmentShaderFilename:@"Lightning"];
        [self bindLocation];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)pbProgramWillSemiautoDraw:(PBProgram *)aProgram
{

}


@end