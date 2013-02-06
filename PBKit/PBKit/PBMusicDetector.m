/*
 *  PBMusicDetector.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 6..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBMusicDetector.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


static BOOL gCanPlay = NO;


@implementation PBMusicDetector


+ (void)detect
{
    UInt32 sPropertySize;
    UInt32 sIsAudioAlreadyPlaying;
    
    sPropertySize = sizeof(UInt32);
    AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &sPropertySize, &sIsAudioAlreadyPlaying);
    
    if (sIsAudioAlreadyPlaying)
    {
        gCanPlay = NO;
    }
    else
    {
        gCanPlay = YES;
    }
}


+ (BOOL)canPlay
{
    return gCanPlay;
}


@end
