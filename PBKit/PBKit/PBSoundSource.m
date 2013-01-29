/*
 *  PBSoundSource.m
 *  PBKit
 *
 *  Created by cgkim on 12. 4. 9..
 *  Copyright (c) 2012 PrisonBreak. All rights reserved.
 *
 */

#import "PBSoundSource.h"
#import "PBSound.h"
#import "PBSoundBuffer.h"


@implementation PBSoundSource
{
    ALuint   mSource;
    PBSound *mSound;
}


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
    [mSound release];
    
    if (mSource)
    {
        alDeleteSources(1, &mSource);
    }
    
    [super dealloc];
}


#pragma mark -


- (void)setSound:(PBSound *)aSound
{
    [self setBuffer:[aSound buffer]];
    
    [mSound autorelease];
    mSound = [aSound retain];
}


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


- (void)setBuffer:(PBSoundBuffer *)aBuffer
{
    ALenum sError;
    
    alGetError();
    alSourcei(mSource, AL_BUFFER, [aBuffer buffer]);
    
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
