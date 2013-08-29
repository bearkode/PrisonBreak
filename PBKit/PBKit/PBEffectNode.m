/*
 *  PBEffectNode.m
 *  PBKit
 *
 *  Created by camelkode on 13. 7. 2..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBEffectNode.h"
#import "PBNodePrivate.h"
#import "PBProgram.h"


@implementation PBEffectNode
{
    PBProgram *mProgram;
}


#pragma mark -


- (void)arrangeProgramWithSubNode:(PBNode *)aNode
{
    [[aNode mesh] setProgram:mProgram];
}


- (void)arrangeProgramWithSubNodes:(NSArray *)aSubNodes
{
    for (PBNode *sNode in aSubNodes)
    {
        [self arrangeProgramWithSubNode:sNode];
        if ([sNode subNodes])
        {
            [self arrangeProgramWithSubNodes:[sNode subNodes]];
        }
    }
}


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}


- (void)dealloc
{
    [mProgram release];
    
    [super dealloc];
}


#pragma mark -


- (void)setSubNodes:(NSArray *)aSubNodes
{
    [super setSubNodes:aSubNodes];
    
    [self arrangeProgramWithSubNode:self];
    [self arrangeProgramWithSubNodes:aSubNodes];
}


- (void)addSubNode:(PBNode *)aNode
{
    [super addSubNode:aNode];
    
    [self arrangeProgramWithSubNode:aNode];
    if ([aNode subNodes])
    {
        [self arrangeProgramWithSubNodes:[aNode subNodes]];
    }
}


- (void)addSubNodes:(NSArray *)aNodes
{
    [super addSubNodes:aNodes];
    
    [self arrangeProgramWithSubNodes:aNodes];
}


#pragma mark -


- (void)setProgram:(PBProgram *)aProgram
{
    [mProgram autorelease];
    mProgram = [aProgram retain];
    
    [self arrangeProgramWithSubNode:self];
    [self arrangeProgramWithSubNodes:[self subNodes]];
}


@end


