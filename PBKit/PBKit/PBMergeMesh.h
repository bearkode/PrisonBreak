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
- (NSUInteger)meshCount;


- (GLfloat *)vertices;
- (GLfloat *)coordinates;


@end
