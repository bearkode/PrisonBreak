/*
 *  PBMeshRenderer.h
 *  PBKit
 *
 *  Created by camelkode on 13. 3. 29..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBMeshRenderer.h"


#define MESHRENDERER_USE_NSARRAY 0


@class PBMesh;


@interface PBMeshRenderer : NSObject


+ (PBMeshRenderer *)sharedManager;


#pragma mark -


- (void)setMaxMeshQueueCount:(NSInteger)aCount;


- (void)addMesh:(PBMesh *)aMesh;
#if (MESHRENDERER_USE_NSARRAY)
- (void)removeMesh:(PBMesh *)aMesh;
#endif


- (void)setSelectionMode:(BOOL)aSelection;


- (void)vacate;
- (void)render;

- (void)renderOffscreenToOnscreenWithCanvasSize:(CGSize)aCanvasSize offscreenTextureHandle:(GLuint)aTextureHandle;


@end
