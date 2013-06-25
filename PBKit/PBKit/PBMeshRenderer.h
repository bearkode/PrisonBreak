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


+ (PBMeshRenderer *)sharedManager;


#pragma mark -


- (void)setMaxMeshQueueCount:(NSInteger)aCount;
- (void)addMesh:(PBMesh *)aMesh;


- (void)setSelectionMode:(BOOL)aSelection;

- (void)vacate;

- (void)render;
- (void)renderToTexture:(GLuint)aHandle withCanvasSize:(CGSize)aCanvasSize;


@end
