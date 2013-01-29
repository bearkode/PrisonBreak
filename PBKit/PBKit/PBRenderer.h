/*
 *  PBRenderer.h
 *  PBKit
 *
 *  Created by sshanks on 13. 1. 25..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */




#import <Foundation/Foundation.h>


@class PBColor;
@class PBView;


@interface PBRenderer : NSObject
{
    GLint  mDisplayWidth;
    GLint  mDisplayHeight;
}


@property (nonatomic, readonly) GLint  displayWidth;
@property (nonatomic, readonly) GLint  displayHeight;


#pragma mark -


- (BOOL)createBufferWithLayer:(CAEAGLLayer *)aLayer;
- (void)destroyBuffer;


#pragma mark -


- (void)displayView:(PBView *)aView
    backgroundColor:(PBColor *)aColor
           delegate:(id)aDelegate
           selector:(SEL)aSelector;


@end
