/*
 *  PBSound.h
 *  PBKit
 *
 *  Created by cgkim on 10. 2. 16..
 *  Copyright 2010 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <OpenAL/al.h>


@class PBSoundBuffer;
@class PBSoundSource;


@interface PBSound : NSObject
{
    NSString      *mName;
    CGFloat        mDistance;
    CGPoint        mPosition;
    BOOL           mIsPlaying;
    BOOL           mIsLooping;

    PBSoundBuffer *mBuffer;
    PBSoundSource *mSource;
}

@property (nonatomic, readonly) NSString      *name;
@property (nonatomic, readonly) CGPoint        position;
@property (nonatomic, readonly) BOOL           isPlaying;
@property (nonatomic, readonly) BOOL           isLooping;
@property (nonatomic, readonly) PBSoundBuffer *buffer;
@property (nonatomic, readonly) PBSoundSource *source;

- (id)initWithName:(NSString *)aName isLooping:(BOOL)aIsLooping;

- (void)setLooping:(BOOL)aLooping;
- (void)play;
- (void)stop;

@end
