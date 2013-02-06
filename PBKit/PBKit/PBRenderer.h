/*
 *  PBRenderer.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */




#import <Foundation/Foundation.h>
#import "PBTransform.h"


@class PBColor;
@class PBRenderable;


@interface PBRenderer : NSObject
{
    GLint     mDisplayWidth;
    GLint     mDisplayHeight;
    
    PBMatrix4 mProjection;
}


@property (nonatomic, readonly) GLint displayWidth;
@property (nonatomic, readonly) GLint displayHeight;


#pragma mark -


- (BOOL)createBufferWithLayer:(CAEAGLLayer *)aLayer;
- (void)destroyBuffer;
- (void)bindingBuffer;
- (void)clearBackgroundColor:(PBColor *)aColor;
- (void)generateProjectionMatrix;


#pragma mark -


- (void)display:(PBRenderable *)aRenderable;


@end
