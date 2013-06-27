/*
 *  BasicParticle.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 22..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "BasicParticle.h"
#import <PBKit.h>


#define kParticleDataSize 7


@implementation BasicParticle


@synthesize particleCount = mParticleCount;
@synthesize speed         = mSpeed;


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
        (*sParticleData++) = 1;
        
        (*sParticleData++) = aStartCoordinate.x;
        (*sParticleData++) = aStartCoordinate.y;
        (*sParticleData++) = 0;
    }
    
    mPlayTime = 0.0f;
    mFire     = YES;
}


- (void)bindProgram
{   
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
        return;
    }
    
    [self bindProgram];
    
    mPlayTime += mSpeed;
    
    glUniform1f(mTotalTime, mPlayTime);
    
    glVertexAttribPointer(mParticleTime, 1, GL_FLOAT, GL_FALSE, kParticleDataSize * sizeof(GLfloat), mParticleData);
    glEnableVertexAttribArray(mParticleTime);
    
    glVertexAttribPointer(mEndPosition, 3, GL_FLOAT, GL_FALSE, kParticleDataSize * sizeof(GLfloat), &mParticleData[1]);
    glEnableVertexAttribArray(mEndPosition);
    
    glVertexAttribPointer(mStartPosition, 3, GL_FLOAT, GL_FALSE, kParticleDataSize * sizeof(GLfloat), &mParticleData[4]);
    glEnableVertexAttribArray(mStartPosition);
    
    glBindTexture(GL_TEXTURE_2D, [mTexture handle]);
    glDrawArrays(GL_POINTS, 0, mParticleCount);
    
    glDisableVertexAttribArray(mParticleTime);
    glDisableVertexAttribArray(mEndPosition);
    glDisableVertexAttribArray(mStartPosition);
    glBindTexture(GL_TEXTURE_2D, 0);
}


#pragma mark -


- (id)initWithTexture:(PBTexture *)aTexture
{
    self = [super init];
    if (self)
    {
        mTexture  = [aTexture retain];
        mPlayTime = 0.0f;
        mSpeed    = 0.03;
        
        mProgram  = [[PBProgram alloc] init];
        [mProgram linkVertexShaderFilename:@"BasicParticle" fragmentShaderFilename:@"BasicParticle"];
    }
    
    return self;
}


- (void)dealloc
{
    if (mParticleData)
    {
        free(mParticleData);
    }
    
    [mProgram release];
    [mTexture release];
    
    [super dealloc];
}


@end
