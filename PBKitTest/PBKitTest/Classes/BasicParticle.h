/*
 *  BasicParticle.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 22..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


typedef void (^PlaybackBlock)();


@class PBTexture;
@class PBProgram;


@interface BasicParticle : NSObject
{
    PBTexture       *mTexture;
    PBProgram       *mProgram;
    PlaybackBlock    mPlaybackBlock;
    
    GLint            mParticleTime;
    GLint            mStartPosition;
    GLint            mEndPosition;
    GLint            mTotalTime;
    
    CGFloat          *mParticleData;
    CGFloat          mPlayTime;
    CGFloat          mSpeed;
    
    BOOL             mFire;
    NSUInteger       mParticleCount;
}


@property (nonatomic, copy)   PlaybackBlock playbackBlock;
@property (nonatomic, retain) PBTexture    *texture;
@property (nonatomic, assign) NSUInteger    particleCount;
@property (nonatomic, assign) CGFloat       speed;


- (id)initWithTexture:(PBTexture *)aTexture;


- (void)finished;
- (void)fire:(CGPoint)aStartCoordinate;
- (void)draw;


@end
