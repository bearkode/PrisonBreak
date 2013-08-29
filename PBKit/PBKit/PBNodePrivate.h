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


#pragma mark -
#pragma mark PBSpriteNode Privates


@interface PBSpriteNode (Private)


- (void)setTileSize:(CGSize)aSize;
- (void)setTileIndex:(NSInteger)aTileIndex;
- (NSInteger)tileIndex;


@end

#endif
