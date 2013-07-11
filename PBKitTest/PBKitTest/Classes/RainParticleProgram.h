/*
 *  RainParticleProgram.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 10..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBParticleProgram.h>


@interface RainParticleProgram : PBParticleProgram <PBProgramEffectDelegate>


- (void)setEmitter:(PBParticleEmitter)aEmitter arrangeData:(BOOL)aArrange;


@end
