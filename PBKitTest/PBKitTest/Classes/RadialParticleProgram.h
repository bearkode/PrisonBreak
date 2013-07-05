/*
 *  RadialParticleProgram.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 4..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "PBProgram.h"


typedef void (^CompletionBlock)();


@interface RadialParticleProgram : PBProgram <PBProgramDelegate>


@property (nonatomic, assign) CGFloat    speed;
@property (nonatomic, assign) NSUInteger count;


- (void)setCompletionBlock:(CompletionBlock)aCallback;


- (void)reset;
- (void)update;


@end
