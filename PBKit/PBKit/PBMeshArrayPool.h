/*
 *  PBMeshArrayPool.h
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 27..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


@class PBMeshArray;


@interface PBMeshArrayPool : NSObject


#pragma mark --


+ (PBMeshArray *)meshArrayForSize:(CGSize)aSize createIfNotExist:(BOOL)aCreate;
+ (PBMeshArray *)meshArrayForSize:(CGSize)aSize;
+ (void)addMeshArrayForSize:(CGSize)aSize;
+ (void)removeMeshArrayForSize:(CGSize)aSize;
+ (void)removeAllMeshArrays;


@end
