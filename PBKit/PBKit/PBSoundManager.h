/*
 *  PBSoundManager.h
 *  PBKit
 *
 *  Created by cgkim on 10. 2. 11..
 *  Copyright 2010 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>


//#define kDefaultDistance 25.0


@class PBSound;


@interface PBSoundManager : NSObject

//@property (nonatomic, readonly) ALCcontext *context;
@property (nonatomic, assign)   BOOL        wasInterrupted;           /*    Whether playback was interrupted by the system  */
//@property (nonatomic, readonly) NSString   *currentBGM;

+ (PBSoundManager *)sharedManager;

//- (void)setEnabled:(BOOL)aFlag;
//
//- (void)startSound:(NSString *)aSoundID;
//- (void)startSound:(NSString *)aSoundID looping:(BOOL)aLooping;
//- (void)stopSound:(NSString *)aSoundID;
//- (void)stopSounds:(NSArray *)aSoundIDs;

- (void)addSound:(PBSound *)aSound forKey:(NSString *)aSoundKey;

- (void)addSound:(NSString *)aSoundID;
- (void)removeSound:(NSString *)aSoundID;
- (void)addSounds:(NSArray *)aSoundIDs;
- (void)removeSounds:(NSArray *)aSoundIDs;

//- (void)startBGM:(NSString *)aSoundID;
//- (void)stopBGM;
//- (void)removeBGMs;

@end
