/*
 *  PBCamera.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 6..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "PBMatrix.h"


@interface PBCamera : NSObject


@property(nonatomic, assign)   CGFloat  zoomScale;
@property(nonatomic, assign)   CGPoint  position;
@property(nonatomic, assign)   CGSize   viewSize;
@property(nonatomic, readonly) PBMatrix projection;


#pragma mark -


- (void)setZoomScale:(CGFloat)aZoomScale;
- (void)setPosition:(CGPoint)aPosition;
- (void)setViewSize:(CGSize)aViewSize;

- (BOOL)didProjectionChange;


#pragma mark -


- (void)resetCoordinates;


#pragma mark -


- (CGPoint)convertPointToCanvas:(CGPoint)aPoint;
- (CGPoint)convertPointToView:(CGPoint)aPoint;


@end
