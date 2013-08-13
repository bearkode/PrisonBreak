/*
 *  SpurtParticleProgram.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 8. 12..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBParticleProgram.h>


@interface SpurtParticleProgram : PBParticleProgram <PBProgramDrawDelegate>


- (void)setEmitter:(PBParticleEmitter)aEmitter arrangeData:(BOOL)aArrange;


@end
