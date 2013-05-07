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


@class PBMesh;
@class PBMeshArray;


@interface PBMeshArrayPool : NSObject


#pragma mark --


+ (PBMeshArray *)meshArrayWithMesh:(PBMesh *)aMesh;

+ (void)vacate;

+ (void)printMeshKeys;


@end
