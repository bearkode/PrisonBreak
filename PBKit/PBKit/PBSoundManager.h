/*
 *  PBSoundManager.h
 *  PBKit
 *
 *  Created by bearkode on 10. 2. 11..
 *  Copyright 2010 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>


@class PBSound;
@class PBSoundSource;


@interface PBSoundManager : NSObject


@property (nonatomic, assign) BOOL wasInterrupted;           /*    Whether playback was interrupted by the system  */


+ (PBSoundManager *)sharedManager;


/*  Sound Management  */
- (void)loadSoundNamed:(NSString *)aSoundName forKey:(NSString *)aSoundKey;
- (PBSound *)soundForKey:(NSString *)aSoundKey;
- (void)unloadSoundForKey:(NSString *)aSoundKey;


/*  Source Management  */
- (PBSoundSource *)retainSoundSource;
- (void)releaseSoundSource:(PBSoundSource *)aSoundSource;


@end
