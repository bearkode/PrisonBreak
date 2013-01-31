/*
 *  PBSoundListener.h
 *  PBKit
 *
 *  Created by bearkode on 13. 1. 30..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface PBSoundListener : NSObject

+ (CGPoint)position;
+ (void)setPosition:(CGPoint)aPosition;
+ (CGFloat)orientation;
+ (void)setOrientation:(CGFloat)aRadians;

@end
