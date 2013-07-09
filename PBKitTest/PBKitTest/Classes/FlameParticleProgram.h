/*
 *  FlameParticleProgram.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 9..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBParticleProgram.h>


@interface FlameParticleProgram : PBParticleProgram <PBProgramEffectDelegate>


- (void)setEmitter:(PBParticleEmitter)aEmitter arrangeData:(BOOL)aArrange;


@end
