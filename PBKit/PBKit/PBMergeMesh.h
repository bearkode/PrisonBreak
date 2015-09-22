/*
 *  PBMergeMesh.h
 *  PBKit
 *
 *  Created by camelkode on 13. 9. 26..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBMesh.h"


@interface PBMergeMesh : PBMesh


- (void)setCapacity:(NSUInteger)aCapacity;
- (void)attachMesh:(PBMesh *)aMesh;
- (uint32_t)meshCount;


@end
