/*
 *  LaserProgram.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 11..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "PBProgram.h"


@interface LaserProgram : PBProgram


@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, retain) PBColor *color;


- (void)fire;
- (void)stop;
- (void)setCamera:(PBCamera *)aCamera;


@end
