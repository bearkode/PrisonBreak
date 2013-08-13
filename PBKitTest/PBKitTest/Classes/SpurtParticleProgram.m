/*
 *  SpurtParticleProgram.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 8. 12..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBKit.h>
#import "SpurtParticleProgram.h"


#define kSpurtEmitterDataSize 8


typedef struct {
    GLint lifeSpanLoc;
    GLint startPositionLoc;
    GLint endPositionLoc;
    GLint durationLifeSpanLoc;
    GLint zoomScaleLoc;
    
} SpurtParticleLocation;


@implementation SpurtParticleProgram
{
    SpurtParticleLocation mLocation;
    GLfloat              *mEmitterData;
    NSInteger             mSpurtParticleCount;
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
    mSpurtParticleCount        = 0;
    mEmitterData = malloc(sizeof(GLfloat) * (sEmitter.count * kSpurtEmitterDataSize));
    
    for (NSInteger i = 0; i < sEmitter.count; i++)
    {
        GLfloat *sEmitterData = &mEmitterData[i * kSpurtEmitterDataSize];
        
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
    for (NSInteger i = 0; i < mSpurtParticleCount; i++)
    {
        NSInteger sOffset           = i * kSpurtEmitterDataSize + 1;
        GLfloat   sDurationLifeSpan = mEmitterData[sOffset];
        sDurationLifeSpan          += [self emitter].speed;
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
        [self setMode:kPBProgramModeManual];
        [self setDelegate:self];
        [self linkVertexShaderFilename:@"SpurtParticle" fragmentShaderFilename:@"SpurtParticle"];
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
    
    if (mSpurtParticleCount < [self emitter].count)
    {
        mSpurtParticleCount += 5;
    }
    else
    {
        if ([self emitter].loop)
        {
            [self arrangeEmitterData];
        }
    }
}


#pragma mark - PBProgramDrawDelegate


- (void)pbProgramWillManualDraw:(PBProgram *)aProgram
{
    glDisable(GL_DEPTH_TEST);
    [self arrangeDurationLifeSpan];
    
    glUniform1f(mLocation.zoomScaleLoc, [self emitter].zoomScale);
    
    glVertexAttribPointer(mLocation.lifeSpanLoc, 1, GL_FLOAT, GL_FALSE, kSpurtEmitterDataSize * sizeof(GLfloat), mEmitterData);
    glVertexAttribPointer(mLocation.durationLifeSpanLoc, 1, GL_FLOAT, GL_FALSE, kSpurtEmitterDataSize * sizeof(GLfloat), &mEmitterData[1]);
    glVertexAttribPointer(mLocation.startPositionLoc, 3, GL_FLOAT, GL_FALSE, kSpurtEmitterDataSize * sizeof(GLfloat), &mEmitterData[2]);
    glVertexAttribPointer(mLocation.endPositionLoc, 3, GL_FLOAT, GL_FALSE, kSpurtEmitterDataSize * sizeof(GLfloat), &mEmitterData[5]);
    
    glEnableVertexAttribArray(mLocation.lifeSpanLoc);
    glEnableVertexAttribArray(mLocation.durationLifeSpanLoc);
    glEnableVertexAttribArray(mLocation.endPositionLoc);
    glEnableVertexAttribArray(mLocation.startPositionLoc);
    
    glDrawArrays(GL_POINTS, 0, mSpurtParticleCount);
    
    glDisableVertexAttribArray(mLocation.lifeSpanLoc);
    glDisableVertexAttribArray(mLocation.durationLifeSpanLoc);
    glDisableVertexAttribArray(mLocation.endPositionLoc);
    glDisableVertexAttribArray(mLocation.startPositionLoc);
    glEnable(GL_DEPTH_TEST);
}


@end