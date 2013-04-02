/*
 *  PBMeshRenderer.h
 *  PBKit
 *
 *  Created by camelkode on 13. 3. 29..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBMeshRenderer.h"


@class PBMesh;


@interface PBMeshRenderer : NSObject


+ (void)setMaxMeshQueueCount:(NSInteger)aCount;

+ (void)addMesh:(PBMesh *)aMesh;
+ (void)removeMesh:(PBMesh *)aMesh;

+ (void)vacate;
+ (void)render;


@end
