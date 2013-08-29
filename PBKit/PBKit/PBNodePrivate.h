/*
 *  PBNodePrivate.h
 *  PBKit
 *
 *  Created by camelkode on 13. 6. 27..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#ifndef PBKit_PBNodePrivate_h
#define PBKit_PBNodePrivate_h

#import "PBNode.h"
#import "PBSpriteNode.h"


@class PBMesh;


#pragma mark -
#pragma mark PBNode Privates


@interface PBNode (Private)


- (PBMesh *)mesh;
- (void)setMesh:(PBMesh *)aMesh;


@end


#endif
