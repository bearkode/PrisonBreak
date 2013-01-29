/*
 *  PBSoundBuffer.m
 *  PBKit
 *
 *  Created by cgkim on 12. 4. 9..
 *  Copyright (c) 2012 PrisonBreak. All rights reserved.
 *
 */

#import "PBSoundBuffer.h"
#import "PBSoundData.h"


@implementation PBSoundBuffer


@synthesize buffer = mBuffer;


#pragma mark -


- (id)initWithName:(NSString *)aName
{
    self = [super init];
    
    if (self)
    {
        mName = [aName copy];
        alGenBuffers(1, &mBuffer);

        ALenum       sError     = AL_NO_ERROR;
        NSString    *sName      = [mName stringByDeletingPathExtension];
        NSString    *sExt       = [mName pathExtension];
        PBSoundData *sSoundData = [[PBSoundData alloc] initWithPath:[[NSBundle mainBundle] pathForResource:sName ofType:sExt]];
        
        alBufferData(mBuffer, [sSoundData format], [sSoundData data], [sSoundData size], [sSoundData freq]);
        
        if ((sError = alGetError()) != AL_NO_ERROR)
        {
            NSLog(@"error loading sound: %x\n", sError);
            /* 전화 받고 난 뒤, 첫번째 addSound 할 때만 발생함 */
            //exit(1);
        }
        
        [sSoundData release];
    }
    
    return self;
}


- (id)initWithSoundData:(PBSoundData *)aSoundData
{
    self = [super init];
    
    if (self)
    {
        alGenBuffers(1, &mBuffer);
        
        ALenum sError = AL_NO_ERROR;
        
        alBufferData(mBuffer, [aSoundData format], [aSoundData data], [aSoundData size], [aSoundData freq]);
        
        if ((sError = alGetError()) != AL_NO_ERROR)
        {
            NSLog(@"error loading sound: %x !!", sError);
            /* 전화 받고 난 뒤, 첫번째 addSound 할 때만 발생함 */
            //exit(1);
        }
    }
    
    return self;
}


- (void)dealloc
{
    [mName release];
    if (mBuffer)
    {
        alDeleteBuffers(1, &mBuffer);
    }
    
    [super dealloc];
}


@end
