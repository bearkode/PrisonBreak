/*
 *  PBSoundManager.m
 *  PBKit
 *
 *  Created by bearkode on 10. 2. 11..
 *  Copyright 2010 PrisonBreak. All rights reserved.
 *
 */

#import "PBSoundManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/ExtendedAudioFile.h>
#import "PBObjCUtil.h"
#import "PBSound.h"
#import "PBSoundSource.h"


static ALCdevice  *gDevice  = NULL;
static ALCcontext *gContext = NULL;


#pragma mark -


static void PBAudioSessionInterruptionListener(void *aClientData, UInt32 aInterruptionState)
{
    OSStatus        sResult;
    PBSoundManager *sSoundManager = (PBSoundManager*)aClientData;
    
	if (aInterruptionState == kAudioSessionBeginInterruption)
	{
        alcMakeContextCurrent(NULL);
//        if ([sPlayback isPlaying])
//        {
            [sSoundManager setWasInterrupted:YES];
//        }
	}
	else if (aInterruptionState == kAudioSessionEndInterruption)
	{
        sResult = AudioSessionSetActive(true);
		if (sResult)
        {
            NSLog(@"Error setting audio session active! %ld\n", sResult);
        }
        
		alcMakeContextCurrent(gContext);
        
		if ([sSoundManager wasInterrupted])
		{
//			[sPlayback startSound];			
            [sSoundManager setWasInterrupted:NO];
		}
	}
}


static void PBAudioSessionRouteChangeListener(void *aClientData, AudioSessionPropertyID aID, UInt32 aDataSize, const void *aData)
{
	CFDictionaryRef sDict     = (CFDictionaryRef)aData;
	CFStringRef     sOldRoute = CFDictionaryGetValue(sDict, CFSTR(kAudioSession_AudioRouteChangeKey_OldRoute));
	UInt32          sSize     = sizeof(CFStringRef);
	CFStringRef     sNewRoute;
	OSStatus        sResult   = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &sSize, &sNewRoute);
    
    NSLog(@"result: %ld Route changed from %@ to %@", sResult, sOldRoute, sNewRoute);
}


@implementation PBSoundManager
{
    BOOL                 mWasInterrupted;
    BOOL                 mIsSoundOn;
    
    NSMutableDictionary *mSoundDict;
    NSMutableArray      *mRestSoundSources;
    NSMutableArray      *mUsedSoundSources;
}


SYNTHESIZE_SINGLETON_CLASS(PBSoundManager, sharedManager)


@synthesize wasInterrupted = mWasInterrupted;

#pragma mark -


- (void)initOpenAL
{
	ALenum sError;
	
	gDevice  = alcOpenDevice(NULL);
    gContext = alcCreateContext(gDevice, 0);
    
    alcMakeContextCurrent(gContext);
    
    sError = (alGetError()) != AL_NO_ERROR;
    if (sError)
    {
        NSLog(@"Error %x\n", sError);
    }
}


- (void)releaseALObjects
{	
    alcDestroyContext(gContext);
    alcCloseDevice(gDevice);
}


#pragma mark -


- (id)init
{	
    OSStatus sResult;
    UInt32   sIsiPodPlaying;
    UInt32   sSize;
    UInt32   sCategory;
    
    self = [super init];
    
	if (self)
    {
		mWasInterrupted = NO;
        mIsSoundOn      = YES;
		
        sResult = AudioSessionInitialize(NULL, NULL, PBAudioSessionInterruptionListener, self);
		if (sResult)
        {
            NSLog(@"Error initializing audio session! %ld\n", sResult);
        }
        
        sSize   = sizeof(sIsiPodPlaying);
        sResult = AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &sSize, &sIsiPodPlaying);
        if (sResult)
        {
            NSLog(@"Error getting other audio playing property! %ld", sResult);
        }
        
        if (sIsiPodPlaying)
        {
            sCategory = (sIsiPodPlaying) ? kAudioSessionCategory_AmbientSound : kAudioSessionCategory_SoloAmbientSound;            
            sResult = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sCategory), &sCategory);
            if (sResult)
            {
                NSLog(@"Error setting audio session category! %ld\n", sResult);
            }
        }

        sResult = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, PBAudioSessionRouteChangeListener, self);
        if (sResult)
        {
            NSLog(@"Couldn't add listener: %ld", sResult);
        }
        
        sResult = AudioSessionSetActive(true);
        if (sResult)
        {
            NSLog(@"Error setting audio session active! %ld\n", sResult);
        }
        
		[self initOpenAL];
        
        mSoundDict = [[NSMutableDictionary alloc] init];
        mRestSoundSources = [[NSMutableArray alloc] init];
        mUsedSoundSources = [[NSMutableArray alloc] init];
	}
    
	return self;
}


- (void)dealloc
{
	[self releaseALObjects];

    [mSoundDict release];
    [mRestSoundSources release];
    [mUsedSoundSources release];
    
	[super dealloc];
}


#pragma mark -


- (void)setEnabled:(BOOL)aFlag
{
    mIsSoundOn = aFlag;
    
    if (mIsSoundOn)
    {
    
    }
    else
    {

    }
}


#pragma mark -
#pragma mark Sound Management


- (void)loadSoundNamed:(NSString *)aSoundName forKey:(NSString *)aSoundKey
{
    PBSound *sSound = [PBSound soundNamed:aSoundName];
    
    [mSoundDict setObject:sSound forKey:aSoundKey];
}


- (PBSound *)soundForKey:(NSString *)aSoundKey
{
    return [mSoundDict objectForKey:aSoundKey];
}


- (void)unloadSoundForKey:(NSString *)aSoundKey
{
    [mSoundDict removeObjectForKey:aSoundKey];
}


#pragma mark -
#pragma mark Source Management


- (PBSoundSource *)retainSoundSource
{
    PBSoundSource *sSource = nil;
    
    if ([mRestSoundSources count])
    {
        sSource = [mRestSoundSources lastObject];
        [mUsedSoundSources addObject:sSource];
    }
    else
    {
        sSource = [[[PBSoundSource alloc] init] autorelease];
        [mUsedSoundSources addObject:sSource];
    }
    
    return sSource;
}


- (void)releaseSoundSource:(PBSoundSource *)aSoundSource
{
    [aSoundSource stop];
    
    if (![mRestSoundSources containsObject:aSoundSource])
    {
        [mRestSoundSources addObject:aSoundSource];
    }

    [mUsedSoundSources removeObject:aSoundSource];
}


@end
