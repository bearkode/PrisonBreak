/*
 *  PBSoundSource.h
 *  PBKit
 *
 *  Created by bearkode on 12. 4. 9..
 *  Copyright (c) 2012 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <OpenAL/al.h>


@class PBSound;
@class PBSoundBuffer;


@interface PBSoundSource : NSObject


@property (nonatomic, readonly) ALuint source;


- (void)setSound:(PBSound *)aSound;

- (void)setLooping:(BOOL)aIsLooping;
- (void)setPositionfv:(ALfloat *)aPosition;
- (void)setPosition:(CGPoint)aPosition;
- (void)setDistance:(ALfloat)aDistance;
- (void)setBuffer:(PBSoundBuffer *)aBuffer;

- (void)play;
- (void)stop;
- (BOOL)isPlaying;


@end
