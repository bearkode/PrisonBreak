/*
 *  PBCamera.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 6..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface PBCamera : NSObject

@property(nonatomic, assign) CGFloat zoomScale;

- (CGPoint)position;
- (void)setPosition:(CGPoint)aPosition;

@end
