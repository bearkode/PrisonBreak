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


@interface PBSoundSource : NSObject
{
    ALuint mSource;
}

- (void)setLooping:(BOOL)aIsLooping;
- (void)setPosition:(ALfloat *)aPosition;
- (void)setDistance:(ALfloat)aDistance;
- (void)setBuffer:(ALuint)aBuffer;

- (void)play;
- (void)stop;

@end
