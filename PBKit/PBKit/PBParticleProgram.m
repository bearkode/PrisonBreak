/*
 *  PBParticleProgram.m
 *  PBKit
 *
 *  Created by camelkode on 13. 7. 8..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


#import "PBParticleProgram.h"


PBParticleEmitter initEmitter()
{
    PBParticleEmitter sEmitter;
    sEmitter.currentSpan           = 0;
    sEmitter.count                 = 0;
    sEmitter.lifeSpan              = 0.0;
    sEmitter.durationLifeSpan      = 0.0;
    sEmitter.startPosition         = PBVertex3Make(0.0, 0.0, 0.0);
    sEmitter.startPositionVariance = PBVertex3Make(0.0, 0.0, 0.0);
    sEmitter.endPosition           = PBVertex3Make(0.0, 0.0, 0.0);
    sEmitter.endPositionVariance   = PBVertex3Make(0.0, 0.0, 0.0);
    sEmitter.speed                 = 0.0;
    sEmitter.loop                  = false;
    sEmitter.zoomScale             = 0.0;
    sEmitter.alpha                 = 1.0;
    sEmitter.viewPortWidth         = 0.0;
    sEmitter.viewPortHeight        = 0.0;
    
    return sEmitter;
}


@implementation PBParticleProgram
{
    PBEmitterCompletionBlock mCompletionBlock;
    PBParticleEmitter        mEmitter;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        [self setMode:kPBProgramModeManual];
    }
    
    return self;
}


- (void)dealloc
{
    [mCompletionBlock release];

    [super dealloc];
}


#pragma mark -


- (void)setEmitterCompletionBlock:(PBEmitterCompletionBlock)aCallback
{
    if (mCompletionBlock)
    {
        [mCompletionBlock autorelease];
        mCompletionBlock = nil;
    }
    mCompletionBlock = [aCallback copy];
}


- (void)setEmitter:(PBParticleEmitter)aEmitter
{
    mEmitter = aEmitter;
}


- (PBParticleEmitter)emitter
{
    return mEmitter;
}


- (void)setCurrentSpan:(GLfloat)aSpan
{
    mEmitter.currentSpan = aSpan;
}


#pragma mark -


- (void)update
{
    mEmitter.currentSpan += mEmitter.speed;
    
    if (mEmitter.currentSpan > mEmitter.lifeSpan)
    {
        if (mCompletionBlock)
        {
            mCompletionBlock();
            [mCompletionBlock release];
            mCompletionBlock = nil;
        }
    }
}


- (BOOL)isFinished
{
    return NO;
}


@end
