/*
 *  PBSoundData.m
 *  PBKit
 *
 *  Created by cgkim on 12. 4. 9..
 *  Copyright (c) 2012 PrisonBreak. All rights reserved.
 *
 */

#import "PBSoundData.h"
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>


void *PBCreateAudioDataFromFile(CFURLRef aFileURL, ALsizei *aOutDataSize, ALenum *aOutDataFormat, ALsizei *aOutSampleRate)
{
    OSStatus                    sErr = noErr;	
	SInt64						sFileLengthInFrames = 0;
	AudioStreamBasicDescription	sFileFormat;
	UInt32						sPropertySize = sizeof(sFileFormat);
	ExtAudioFileRef				sExtRef = NULL;
	void                       *sData = NULL;
	AudioStreamBasicDescription	sOutputFormat;
    UInt32                      sDataSize;
    AudioBufferList             sDataBuffer;
    
	sErr = ExtAudioFileOpenURL(aFileURL, &sExtRef);
	if (sErr)
    {
        NSLog(@"GetOpenALAudioData: ExtAudioFileOpenURL FAILED, Error = %ld\n", sErr);
        goto Exit;
    }
    
	sErr = ExtAudioFileGetProperty(sExtRef, kExtAudioFileProperty_FileDataFormat, &sPropertySize, &sFileFormat);
	if (sErr)
    {
        NSLog(@"GetOpenALAudioData: ExtAudioFileGetProperty(kExtAudioFileProperty_FileDataFormat) FAILED, Error = %ld\n", sErr);
        goto Exit;
    }
	
    if (sFileFormat.mChannelsPerFrame > 2)
    {
        NSLog(@"GetOpenALAudioData - Unsupported Format, channel count is greater than stereo\n");
        goto Exit;
    }
    
	sOutputFormat.mSampleRate       = sFileFormat.mSampleRate;
	sOutputFormat.mChannelsPerFrame = sFileFormat.mChannelsPerFrame;
	sOutputFormat.mFormatID         = kAudioFormatLinearPCM;
	sOutputFormat.mBytesPerPacket   = 2 * sOutputFormat.mChannelsPerFrame;
	sOutputFormat.mFramesPerPacket  = 1;
	sOutputFormat.mBytesPerFrame    = 2 * sOutputFormat.mChannelsPerFrame;
	sOutputFormat.mBitsPerChannel   = 16;
	sOutputFormat.mFormatFlags      = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
	
	sErr = ExtAudioFileSetProperty(sExtRef, kExtAudioFileProperty_ClientDataFormat, sizeof(sOutputFormat), &sOutputFormat);
	if (sErr)
    {
        NSLog(@"GetOpenALAudioData: ExtAudioFileSetProperty(kExtAudioFileProperty_ClientDataFormat) FAILED, Error = %ld\n", sErr);
        goto Exit;
    }
	
    sPropertySize = sizeof(sFileLengthInFrames);
	sErr = ExtAudioFileGetProperty(sExtRef, kExtAudioFileProperty_FileLengthFrames, &sPropertySize, &sFileLengthInFrames);
	if (sErr)
    {
        NSLog(@"GetOpenALAudioData: ExtAudioFileGetProperty(kExtAudioFileProperty_FileLengthFrames) FAILED, Error = %ld\n", sErr);
        goto Exit;
    }
	
    sDataSize = sFileLengthInFrames * sOutputFormat.mBytesPerFrame;;
    sData     = malloc(sDataSize);
	if (sData)
	{
        sDataBuffer.mNumberBuffers              = 1;
        sDataBuffer.mBuffers[0].mDataByteSize   = sDataSize;
        sDataBuffer.mBuffers[0].mNumberChannels = sOutputFormat.mChannelsPerFrame;
        sDataBuffer.mBuffers[0].mData           = sData;
		
		sErr = ExtAudioFileRead(sExtRef, (UInt32*)&sFileLengthInFrames, &sDataBuffer);
		if(sErr == noErr)
		{
			*aOutDataSize   = (ALsizei)sDataSize;
			*aOutDataFormat = (sOutputFormat.mChannelsPerFrame > 1) ? AL_FORMAT_STEREO16 : AL_FORMAT_MONO16;
			*aOutSampleRate = (ALsizei)sOutputFormat.mSampleRate;
		}
		else 
		{ 
			free(sData);
			sData = NULL;
			NSLog(@"GetOpenALAudioData: ExtAudioFileRead FAILED, Error = %ld\n", sErr);
            goto Exit;
		}	
	}
	
Exit:
	if (sExtRef)
    {
        ExtAudioFileDispose(sExtRef);
    }
    
	return sData;
}


void PBAudioDataRelease(void *aData)
{
    if (aData)
    {
        free(aData);
    }
}


@implementation PBSoundData


@synthesize format = mFormat;
@synthesize data   = mData;
@synthesize size   = mSize;
@synthesize freq   = mFreq;


#pragma mark -


- (id)initWithPath:(NSString *)aPath
{
    self = [super init];
    
    if (self)
    {
        mData = PBCreateAudioDataFromFile((CFURLRef)[NSURL fileURLWithPath:aPath], &mSize, &mFormat, &mFreq);
    }
    
    return self;
}


- (void)dealloc
{
    PBAudioDataRelease(mData);
    
    [super dealloc];
}


@end
