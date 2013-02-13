/*
 *  PBCamera.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 6..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "PBKit.h"


@interface PBCamera : NSObject


@property(nonatomic, assign) CGFloat   zoomScale;
@property(nonatomic, assign) CGPoint   position;
@property(nonatomic, assign) CGSize    viewSize;
@property(nonatomic, assign) PBMatrix4 projection;


#pragma mark -


- (void)setZoomScale:(CGFloat)aZoomScale;


- (void)setPosition:(CGPoint)aPosition;


- (void)setViewSize:(CGSize)aViewSize;


#pragma mark -


- (void)generateCoordinates;
- (void)resetCoordinatesWithLeft:(CGFloat)aLeft right:(CGFloat)aRight bottom:(CGFloat)aBottom top:(CGFloat)aTop;


#pragma mark -


- (CGPoint)convertPointFromView:(CGPoint)aPoint;
- (CGPoint)convertPointToView:(CGPoint)aPoint;


@end
