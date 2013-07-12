/*
 *  RadialParticleProgram.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 4..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBParticleProgram.h>


@interface RadialParticleProgram : PBParticleProgram <PBProgramDrawDelegate>


- (void)setEmitter:(PBParticleEmitter)aEmitter arrangeData:(BOOL)aArrange;


@end
