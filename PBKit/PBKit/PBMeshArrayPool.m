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


NSMutableDictionary *gMeshArrays;


@implementation PBMeshArrayPool


SYNTHESIZE_SINGLETON_CLASS(PBMeshArrayPool, sharedManager)


+ (void)initialize
{
    gMeshArrays = [[NSMutableDictionary alloc] init];
}


#pragma mark --


+ (NSString *)generatorMeshArrayKeyForSize:(CGSize)aSize
{
    if (CGSizeEqualToSize(aSize, CGSizeZero))
    {
        NSLog(@"[PBMeshArrayPool] generatorForKey parameter is CGSizeZero");
    }
    
    return [NSString stringWithFormat:@"<tw=%f_th=%f", aSize.width, aSize.height];
}


#pragma mark --


+ (PBMeshArray *)meshArrayForSize:(CGSize)aSize createIfNotExist:(BOOL)aCreate
{
    NSString    *sKey       = [PBMeshArrayPool generatorMeshArrayKeyForSize:aSize];
    PBMeshArray *sMeshArray = [gMeshArrays objectForKey:sKey];
    
    if (aCreate && !sMeshArray)
    {
        sMeshArray = [[[PBMeshArray alloc] init] autorelease];
        [gMeshArrays setObject:sMeshArray forKey:sKey];
    }
    
//    NSLog(@"[PBMeshArrayPool] pool count = %d", [gMeshArrays count]);
    return sMeshArray;
}


+ (PBMeshArray *)meshArrayForSize:(CGSize)aSize
{
    return [self meshArrayForSize:aSize createIfNotExist:NO];
}


+ (void)addMeshArrayForSize:(CGSize)aSize
{
    NSString *sKey = [PBMeshArrayPool generatorMeshArrayKeyForSize:aSize];
    if (![gMeshArrays objectForKey:sKey])
    {
        PBMeshArray *sMeshArray = [[[PBMeshArray alloc] init] autorelease];
        [gMeshArrays setObject:sMeshArray forKey:sKey];
    }
}


+ (void)removeMeshArrayForSize:(CGSize)aSize
{
    NSString *sKey = [PBMeshArrayPool generatorMeshArrayKeyForSize:aSize];
    [gMeshArrays removeObjectForKey:sKey];
}


+ (void)removeAllMeshArrays
{
    [gMeshArrays removeAllObjects];
}


#pragma mark --


@end
