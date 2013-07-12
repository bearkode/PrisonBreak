/*
 *  PBParticleProgram.m
 *  PBKit
 *
 *  Created by camelkode on 13. 7. 8..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


#import "PBParticleProgram.h"


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



@end
