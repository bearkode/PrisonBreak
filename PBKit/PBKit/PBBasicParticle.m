/*
 *  PBBasicParticle.m
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 22..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "PBKit.h"


#define kParticleDataSize 6


@implementation PBBasicParticle


@synthesize playbackBlock = mPlaybackBlock;
@synthesize particleCount = mParticleCount;
@synthesize speed         = mSpeed;
@synthesize texture       = mTexture;


#pragma mark -


- (void)finished
{
    if (mPlaybackBlock)
    {
        mPlaybackBlock();
        [mPlaybackBlock autorelease];
        mPlaybackBlock = nil;
    }
}


#pragma mark -


- (void)fire:(CGPoint)aStartCoordinate
{
    mParticleData  = malloc(sizeof(CGFloat) * (mParticleCount * kParticleDataSize));
    
    for (NSInteger i = 0; i < mParticleCount; i++)
    {
        float *sParticleData = &mParticleData[i * kParticleDataSize];
        
        (*sParticleData++) = ((float)(arc4random() % 10000) / 10000.0f);

        (*sParticleData++) = ((float)(arc4random() % 10000) / 5000.0f) - 1.0f;
        (*sParticleData++) = ((float)(arc4random() % 10000) / 5000.0f) - 1.0f;
        (*sParticleData++) = ((float)(arc4random() % 10000) / 5000.0f) - 1.0f;
        
        (*sParticleData++) = aStartCoordinate.x;
        (*sParticleData++) = aStartCoordinate.y;
    }
    
    mPlayTime = 0.0f;
    mFire     = YES;
}


- (void)bindProgram
{
    mProgram       = [[PBProgramManager sharedManager] particleProgram];
    
    mParticleTime  = [mProgram attributeLocation:@"aParticleTime"];
    mEndPosition   = [mProgram attributeLocation:@"aEndPosition"];
    mStartPosition = [mProgram attributeLocation:@"aStartPosition"];
    mTotalTime     = [mProgram uniformLocation:@"aTotalTime"];
    
    [mProgram use];
}

- (void)draw
{
    if (!mFire)
    {
        return;
    }
    
    if (mPlayTime >= 1.0f)
    {
        [self finished];
        return;
    }
    
    [self bindProgram];
    
    mPlayTime += mSpeed;
    
    [PBContext performBlockOnMainThread:^{
        glUniform1f(mTotalTime, mPlayTime);
        
        glVertexAttribPointer(mParticleTime, 1, GL_FLOAT, GL_FALSE, kParticleDataSize * sizeof(GLfloat), mParticleData);
        glEnableVertexAttribArray(mParticleTime);
        
        glVertexAttribPointer(mEndPosition, 3, GL_FLOAT, GL_FALSE, kParticleDataSize * sizeof(GLfloat), &mParticleData[1]);
        glEnableVertexAttribArray(mEndPosition);
        
        glVertexAttribPointer(mStartPosition, 2, GL_FLOAT, GL_FALSE, kParticleDataSize * sizeof(GLfloat), &mParticleData[4]);
        glEnableVertexAttribArray(mStartPosition);
        
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, [mTexture handle]);
        glEnable(GL_BLEND);
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        glDrawArrays(GL_POINTS, 0, mParticleCount);
        glDisable(GL_BLEND);
        
        glDisableVertexAttribArray(mParticleTime);
        glDisableVertexAttribArray(mEndPosition);
        glDisableVertexAttribArray(mStartPosition);
    }];
}


#pragma mark -


- (id)initWithTexture:(PBTexture *)aTexture
{
    self = [super init];
    if (self)
    {
        [self setTexture:aTexture];        
        mPlayTime = 0.0f;
        mSpeed    = 0.03;
    }
    
    return self;
}


- (void)dealloc
{
    if (mParticleData)
    {
        free(mParticleData);
    }
    
    [mTexture release];
    [mPlaybackBlock release];
    
    [super dealloc];
}


@end
