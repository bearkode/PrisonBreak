/*
 *  PBParticleProgram.h
 *  PBKit
 *
 *  Created by camelkode on 13. 7. 8..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


#import "PBProgram.h"


typedef void (^PBEmitterCompletionBlock)();


typedef struct {
    // current status
    GLfloat   currentSpan;
    
    // particle configuration
    GLfloat   lifeSpan;
    GLfloat   durationLifeSpan;
    PBVertex3 startPosition;
    PBVertex3 startPositionVariance;
    PBVertex3 endPosition;
    PBVertex3 endPositionVariance;
    
    // gravity configuration
    GLuint    count;
    GLfloat   speed;
    
    GLboolean loop;
    GLfloat   zoomScale;

    GLint     viewPortWidth;
    GLint     viewPortHeight;
    
} PBParticleEmitter;


@interface PBParticleProgram : PBProgram


- (void)setEmitterCompletionBlock:(PBEmitterCompletionBlock)aCallback;


- (void)setEmitter:(PBParticleEmitter)aEmitter;
- (PBParticleEmitter)emitter;
- (void)setCurrentSpan:(GLfloat)aSpan;


- (void)update;


@end
