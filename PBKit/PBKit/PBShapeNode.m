/*
 *  PBShapeNode.h
 *  PBKit
 *
 *  Created by camelkode on 13. 8. 29..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBShapeNode.h"
#import "PBNodePrivate.h"


@implementation PBShapeNode
{
}



#pragma mark -


+ (Class)meshClass
{
    return [PBMesh class];
}


#pragma mark -


+ (id)shapeNodeWithRect:(CGSize)aSize
{
    return [[[PBShapeNode alloc] initWithRectNode:aSize] autorelease];
}


#pragma mark -


- (id)initWithRectNode:(CGSize)aSize
{
    self = [super init];
    
    if (self)
    {
        [[self mesh] setVertexSize:aSize];
    }
    
    return self;
}


- (void)setRect:(CGSize)aSize
{
    [[self mesh] setVertexSize:aSize];
}



- (void)dealloc
{
    [super dealloc];
}



@end
