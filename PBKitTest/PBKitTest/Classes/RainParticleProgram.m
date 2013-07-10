/*
 *  RainParticleProgram.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 10..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBKit.h>
#import "RainParticleProgram.h"


#define kRainEmitterDataSize 8


typedef struct {
    GLint projectionLoc;
    GLint lifeSpanLoc;
    GLint startPositionLoc;
    GLint endPositionLoc;
    GLint durationLifeSpanLoc;
    GLint zoomScaleLoc;
    
} RainParticleLocation;


@implementation RainParticleProgram
{
    RainParticleLocation mLocation;
    GLfloat            *mEmitterData;
    NSInteger            mRaindropCount;
}


#pragma mark -


- (void)arrangeEmitterData
{
    if (mEmitterData)
    {
        free(mEmitterData);
    }
    
    PBParticleEmitter sEmitter = [self emitter];
    sEmitter.currentSpan       = 0.0;
    mRaindropCount             = 0;
    mEmitterData               = malloc(sizeof(GLfloat) * (sEmitter.count * kRainEmitterDataSize));
    for (NSInteger i = 0; i < sEmitter.count; i++)
    {
        GLfloat *sEmitterData = &mEmitterData[i * kRainEmitterDataSize];
        
        (*sEmitterData++) = sEmitter.lifeSpan - ((GLfloat)(arc4random() % 1000) / 1000.0f);
        (*sEmitterData++) = 0.0f;
        
        (*sEmitterData++) = sEmitter.startPosition.x + (((GLfloat)(arc4random() % 1000) / 500.0f) - 1.0f) * sEmitter.startPositionVariance.x;
        (*sEmitterData++) = sEmitter.startPosition.y + (((GLfloat)(arc4random() % 1000) / 500.0f) - 1.0f) * sEmitter.startPositionVariance.y;
        (*sEmitterData++) = sEmitter.startPosition.z;
        
        (*sEmitterData++) = sEmitter.endPosition.x + (((GLfloat)(arc4random() % 1000) / 500.0f) - 1.0f) * sEmitter.endPositionVariance.x;
        (*sEmitterData++) = sEmitter.endPosition.y + (((GLfloat)(arc4random() % 1000) / 500.0f) - 1.0f) * sEmitter.endPositionVariance.y;
        (*sEmitterData++) = sEmitter.endPosition.z;
    }
}


- (void)arrangeDurationLifeSpan
{
    for (NSInteger i = 0; i < mRaindropCount; i++)
    {
        NSInteger sOffset           = i * kRainEmitterDataSize + 1;
        GLfloat   sDurationLifeSpan = mEmitterData[sOffset];
        sDurationLifeSpan          += [self emitter].speed;
        if ((mEmitterData[sOffset + 4] + sDurationLifeSpan) > 1.0)
        {
            sDurationLifeSpan = 0.0;
        }
        mEmitterData[sOffset] = sDurationLifeSpan;
    }
}


- (void)bindLocation
{
    [self setProjectionLocation:[self uniformLocation:@"aProjection"]];
    mLocation.zoomScaleLoc        = [self uniformLocation:@"aZoomScale"];
    mLocation.lifeSpanLoc         = [self attributeLocation:@"aLifeSpan"];
    mLocation.durationLifeSpanLoc = [self attributeLocation:@"aDurationLifeSpan"];
    mLocation.endPositionLoc      = [self attributeLocation:@"aEndPosition"];
    mLocation.startPositionLoc    = [self attributeLocation:@"aStartPosition"];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        [self setType:kPBProgramParticle];
        [self setDelegate:self];
        [self linkVertexShaderFilename:@"RainParticle" fragmentShaderFilename:@"RainParticle"];
        [self bindLocation];
    }
    
    return self;
}


- (void)dealloc
{
    if (mEmitterData)
    {
        free(mEmitterData);
    }
    
    [super dealloc];
}


#pragma mark -


- (void)setEmitter:(PBParticleEmitter)aEmitter arrangeData:(BOOL)aArrange
{
    [super setEmitter:aEmitter];
    
    if (aArrange)
    {
        [self arrangeEmitterData];
    }
}


- (void)update
{
    [super update];
    
    if (mRaindropCount < [self emitter].count)
    {
        mRaindropCount++;
    }
}



#pragma mark - PBProgramEffectDelegate


- (void)pbProgramWillParticleDraw:(PBProgram *)aProgram
{
    glDisable(GL_DEPTH_TEST);
    [self arrangeDurationLifeSpan];

    glUniform1f(mLocation.zoomScaleLoc, [self emitter].zoomScale);
    
    glVertexAttribPointer(mLocation.lifeSpanLoc, 1, GL_FLOAT, GL_FALSE, kRainEmitterDataSize * sizeof(GLfloat), mEmitterData);
    glVertexAttribPointer(mLocation.durationLifeSpanLoc, 1, GL_FLOAT, GL_FALSE, kRainEmitterDataSize * sizeof(GLfloat), &mEmitterData[1]);
    glVertexAttribPointer(mLocation.startPositionLoc, 3, GL_FLOAT, GL_FALSE, kRainEmitterDataSize * sizeof(GLfloat), &mEmitterData[2]);
    glVertexAttribPointer(mLocation.endPositionLoc, 3, GL_FLOAT, GL_FALSE, kRainEmitterDataSize * sizeof(GLfloat), &mEmitterData[5]);
    
    glEnableVertexAttribArray(mLocation.lifeSpanLoc);
    glEnableVertexAttribArray(mLocation.durationLifeSpanLoc);
    glEnableVertexAttribArray(mLocation.endPositionLoc);
    glEnableVertexAttribArray(mLocation.startPositionLoc);


    glDrawArrays(GL_POINTS, 0, mRaindropCount);
    
    glDisableVertexAttribArray(mLocation.lifeSpanLoc);
    glDisableVertexAttribArray(mLocation.durationLifeSpanLoc);
    glDisableVertexAttribArray(mLocation.endPositionLoc);
    glDisableVertexAttribArray(mLocation.startPositionLoc);
    glEnable(GL_DEPTH_TEST);
}


@end