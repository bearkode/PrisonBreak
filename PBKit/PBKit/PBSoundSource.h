/*
 *  PBSoundSource.h
 *  PBKit
 *
 *  Created by cgkim on 12. 4. 9..
 *  Copyright (c) 2012 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <OpenAL/al.h>


@class PBSound;
@class PBSoundBuffer;


@interface PBSoundSource : NSObject

- (void)setSound:(PBSound *)aSound;

- (void)setLooping:(BOOL)aIsLooping;
- (void)setPosition:(ALfloat *)aPosition;
- (void)setDistance:(ALfloat)aDistance;
- (void)setBuffer:(PBSoundBuffer *)aBuffer;

- (void)play;
- (void)stop;

@end
