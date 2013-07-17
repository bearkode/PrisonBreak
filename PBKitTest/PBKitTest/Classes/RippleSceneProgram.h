/*
 *  RippleSceneProgram.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 12..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "PBProgram.h"


@interface RippleSceneProgram : PBProgram <PBProgramDrawDelegate>


- (void)setCamera:(PBCamera *)aCamera;
- (void)setPoint:(CGPoint)aPoint;
- (void)update:(GLuint)aTextureHandle;


@end
