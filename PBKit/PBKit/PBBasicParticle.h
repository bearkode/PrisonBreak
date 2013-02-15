/*
 *  PBBasicParticle.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 22..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


typedef void (^PBPlaybackBlock)();


@interface PBBasicParticle : NSObject
{
    PBTexture       *mTexture;
    PBProgram       *mProgram;
    PBPlaybackBlock  mPlaybackBlock;
    
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


@property (nonatomic, copy)   PBPlaybackBlock playbackBlock;
@property (nonatomic, retain) PBTexture      *texture;
@property (nonatomic, assign) NSUInteger      particleCount;
@property (nonatomic, assign) CGFloat         speed;


- (id)initWithTexture:(PBTexture *)aTexture;


- (void)fire:(CGPoint)aStartCoordinate;
- (void)draw;


@end
