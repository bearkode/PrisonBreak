/*
 *  PBSoundSource.m
 *  PBKit
 *
 *  Created by cgkim on 12. 4. 9..
 *  Copyright (c) 2012 PrisonBreak. All rights reserved.
 *
 */

#import "PBSoundSource.h"


@implementation PBSoundSource


- (id)init
{
    self = [super init];
    
    if (self)
    {
        alGenSources(1, &mSource);
    }
    
    return self;
}


- (void)dealloc
{
    if (mSource)
    {
        alDeleteSources(1, &mSource);
    }
    
    [super dealloc];
}


#pragma mark -


- (void)setLooping:(BOOL)aIsLooping
{
    alSourcei(mSource, AL_LOOPING, aIsLooping);
}


- (void)setPosition:(ALfloat *)aPosition
{
    alSourcefv(mSource, AL_POSITION, aPosition);
}


- (void)setDistance:(ALfloat)aDistance
{
    alSourcef(mSource, AL_REFERENCE_DISTANCE, aDistance);
}


- (void)setBuffer:(ALuint)aBuffer
{
    ALenum sError;
    
    alGetError();
    alSourcei(mSource, AL_BUFFER, aBuffer);
    
    if ((sError = alGetError()) != AL_NO_ERROR)
    {
        NSLog(@"Error attaching buffer to source: %x\n", sError);
    }
}


#pragma mark -


- (void)play
{
    alSourcePlay(mSource);
}


- (void)stop
{
    alSourceStop(mSource);
}


@end
