/*
 *  PBSoundManager.m
 *  PBKit
 *
 *  Created by cgkim on 10. 2. 11..
 *  Copyright 2010 PrisonBreak. All rights reserved.
 *
 */

#import "PBSoundManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/ExtendedAudioFile.h>
#import "PBObjCUtil.h"
#import "PBSound.h"


static ALCdevice  *gDevice  = NULL;
static ALCcontext *gContext = NULL;


#pragma mark -


void interruptionListener(void *aClientData, UInt32 aInterruptionState)
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


void routeChangeListener(void *aClientData, AudioSessionPropertyID aID, UInt32 aDataSize, const void *aData)
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
//    ALCdevice           *mDevice;
//    ALCcontext          *mContext;
    
    BOOL                 mWasInterrupted;
    BOOL                 mIsSoundOn;
    
    NSMutableDictionary *mSoundDict;
    //    NSString            *mCurrentBGM;
}


SYNTHESIZE_SINGLETON_CLASS(PBSoundManager, sharedManager)


//@synthesize context          = mContext;
@synthesize wasInterrupted   = mWasInterrupted;
//@synthesize listenerRotation = mListenerRotation;
//@dynamic    listenerPos;
//@synthesize currentBGM       = mCurrentBGM;


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
        //exit(1);
    }
}


- (void)releaseALObjects
{	
    alcDestroyContext(gContext);
    alcCloseDevice(gDevice);
}


- (void)loadSounds
{
    NSArray *sSoundIDs = [NSArray arrayWithObjects:nil];
    
    for (NSString *sSoundID in sSoundIDs)
    {
        PBSound *sSound = [[[PBSound alloc] initWithName:sSoundID] autorelease];
        [mSoundDict setObject:sSound forKey:sSoundID];
    }
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
		mWasInterrupted   = NO;
        mIsSoundOn        = YES;
		
        sResult = AudioSessionInitialize(NULL, NULL, interruptionListener, self);
		if (sResult)
        {
            NSLog(@"Error initializing audio session! %ld\n", sResult);
        }
        
        sSize = sizeof(sIsiPodPlaying);
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

        sResult = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, routeChangeListener, self);
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
        
        [self loadSounds];
	}
    
	return self;
}


- (void)dealloc
{
	[self releaseALObjects];
    [mSoundDict release];
    
	[super dealloc];
}


#pragma mark Setters / Getters


#pragma mark -


//- (void)setEnabled:(BOOL)aFlag
//{
//    mIsSoundOn = aFlag;
//    
//    if (!mIsSoundOn)
//    {
//        [mCurrentBGM autorelease];
//        mCurrentBGM = nil;
//        
//        [mSoundDict enumerateKeysAndObjectsUsingBlock:^(NSString *aSoundID, PBSound *aSound, BOOL *stop) {
//            [aSound stop];
//        }];
//    }
//}
//
//
//- (void)startSound:(NSString *)aSoundID
//{
//    id sObject = [mSoundDict objectForKey:aSoundID];
//    
//    if ([sObject isMemberOfClass:[PBSound class]])
//    {
//        if (mIsSoundOn)
//        {
//            [(PBSound *)sObject play];
//        }
//    }
//    else
//    {
//        NSLog(@"Sound not found - %@", aSoundID);
//    }
//}
//
//
//- (void)startSound:(NSString *)aSoundID looping:(BOOL)aLooping
//{
//    id sObject = [mSoundDict objectForKey:aSoundID];
//    
//    if ([sObject isMemberOfClass:[PBSound class]])
//    {
//        if (mIsSoundOn)
//        {
//            [(PBSound *)sObject setLooping:aLooping];
//            [(PBSound *)sObject play];
//        }
//    }
//    else
//    {
//        NSLog(@"Sound not found - %@", aSoundID);
//    }
//}
//
//
//- (void)stopSound:(NSString *)aSoundID
//{
//    id sObject = [mSoundDict objectForKey:aSoundID];
//    
//    if ([sObject isMemberOfClass:[PBSound class]])
//    {
//        [(PBSound *)sObject stop];
//    }
//    else
//    {
//        NSLog(@"Sound not found - %@", aSoundID);
//    }
//}
//
//
//- (void)stopSounds:(NSArray *)aSoundIDs
//{
//    for (NSString *sSoundID in aSoundIDs)
//    {
//        [self stopSound:sSoundID];
//    }
//}


#pragma mark -


- (void)addSound:(PBSound *)aSound forKey:(NSString *)aSoundKey
{
    [mSoundDict setObject:aSound forKey:aSoundKey];
}


- (void)addSound:(NSString *)aSoundID
{
    PBSound *sSound = [[[PBSound alloc] initWithName:aSoundID] autorelease];
    [mSoundDict setObject:sSound forKey:aSoundID];
}


- (void)removeSound:(NSString *)aSoundID
{
    [mSoundDict removeObjectForKey:aSoundID];
}


- (void)addSounds:(NSArray *)aSoundIDs
{
    for (NSString *sSoundID in aSoundIDs)
    {
        [self addSound:sSoundID];
    }
}


- (void)removeSounds:(NSArray *)aSoundIDs
{
    for (NSString *sSoundID in aSoundIDs)
    {
        [self removeSound:sSoundID];
    }
}


#pragma mark -


//- (void)startBGM:(NSString *)aSoundID
//{
//    if (![mCurrentBGM isEqualToString:aSoundID])
//    {
//        if (mCurrentBGM)
//        {
//            [self stopSound:mCurrentBGM];
//            [mCurrentBGM autorelease];
//            mCurrentBGM = nil;
//        }
//        
//        if (mIsSoundOn)
//        {
//            mCurrentBGM = [aSoundID retain];
//            
//            if (![mSoundDict objectForKey:aSoundID])
//            {
//                [self addSound:aSoundID];
//            }
//            
//            [self startSound:aSoundID looping:YES];
//        }
//    }
//}
//
//
//- (void)stopBGM
//{
//    [self stopSound:mCurrentBGM];
//    [mCurrentBGM autorelease];
//    mCurrentBGM = nil;
//}
//
//
//- (void)removeBGMs
//{
//    NSMutableArray *sBGMs = [NSMutableArray arrayWithObjects:nil];
//    
//    [sBGMs removeObject:mCurrentBGM];
//    
//    [self removeSounds:sBGMs];
//}


@end
