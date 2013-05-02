/*
 *  PBMeshArrayPool.m
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 27..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBMeshArrayPool.h"
#import "PBObjCUtil.h"
#import "PBMeshArray.h"
#import "PBMesh.h"


NSMutableDictionary *gMeshArrays;


@implementation PBMeshArrayPool


SYNTHESIZE_SINGLETON_CLASS(PBMeshArrayPool, sharedManager)


+ (void)initialize
{
    gMeshArrays = [[NSMutableDictionary alloc] init];
}


#pragma mark --


+ (PBMeshArray *)meshArrayWithMesh:(PBMesh *)aMesh
{
    NSString    *sKey       = [aMesh meshKey];
    PBMeshArray *sMeshArray = [gMeshArrays objectForKey:sKey];
    
    if (!sMeshArray)
    {
        sMeshArray = [[[PBMeshArray alloc] initWithMesh:aMesh] autorelease];
        [gMeshArrays setObject:sMeshArray forKey:sKey];
        
        if ([gMeshArrays count] > 2000)
        {
            [self vacate];
        }
    }
    
    return sMeshArray;
}


+ (void)vacate
{
    [gMeshArrays removeAllObjects];
}


#pragma mark --


@end
