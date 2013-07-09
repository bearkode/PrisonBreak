/*
 *  RadialParticleProgram.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 4..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBKit.h>
#import "RadialParticleProgram.h"


#define kRadialEmitterDataSize 7


typedef struct {
    GLint lifeSpanLoc;
    GLint startPositionLoc;
    GLint endPositionLoc;
    GLint durationLifeSpanLoc;
    GLint zoomScaleLoc;
    
} RadialParticleLocation;


@implementation RadialParticleProgram
{
    RadialParticleLocation mLocation;
    GLfloat               *mEmitterData;
}


#pragma mark -


- (void)arrangeEmitterData
{
    if (mEmitterData)
    {
        free(mEmitterData);
    }
    
    PBParticleEmitter sEmitter = [self emitter];
    mEmitterData = malloc(sizeof(GLfloat) * (sEmitter.count * kRadialEmitterDataSize));
    
    for (NSInteger i = 0; i < sEmitter.count; i++)
    {
        GLfloat *sEmitterData = &mEmitterData[i * kRadialEmitterDataSize];
        
        (*sEmitterData++) = sEmitter.lifeSpan - ((GLfloat)(arc4random() % 1000) / 1000.0f);
        
        (*sEmitterData++) = sEmitter.startPosition.x + (((GLfloat)(arc4random() % 1000) / 500.0f) - 1.0f) * sEmitter.startPositionVariance.x;
        (*sEmitterData++) = sEmitter.startPosition.y + (((GLfloat)(arc4random() % 1000) / 500.0f) - 1.0f) * sEmitter.startPositionVariance.y;
        (*sEmitterData++) = sEmitter.startPosition.z;
        
        (*sEmitterData++) = sEmitter.endPosition.x + (((GLfloat)(arc4random() % 1000) / 500.0f) - 1.0f) * sEmitter.endPositionVariance.x;
        (*sEmitterData++) = sEmitter.endPosition.y + (((GLfloat)(arc4random() % 1000) / 500.0f) - 1.0f) * sEmitter.endPositionVariance.y;
        (*sEmitterData++) = sEmitter.endPosition.z;
    }
}


- (void)bindLocation
{
    [self setProjectionLocation:[self uniformLocation:@"aProjection"]];
    mLocation.zoomScaleLoc        = [self uniformLocation:@"aZoomScale"];
    mLocation.durationLifeSpanLoc = [self uniformLocation:@"aDurationLifeSpan"];
    mLocation.lifeSpanLoc         = [self attributeLocation:@"aLifeSpan"];
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
        [self linkVertexShaderFilename:@"RadialParticle" fragmentShaderFilename:@"RadialParticle"];
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
    
    if ([self emitter].loop)
    {
        if ([self emitter].currentSpan > [self emitter].lifeSpan)
        {
            [self arrangeEmitterData];
            [self setCurrentSpan:0.0];
        }
    }
}


#pragma mark - PBProgramEffectDelegate


- (void)pbProgramWillParticleDraw:(PBProgram *)aProgram
{
    glUniform1f(mLocation.durationLifeSpanLoc, [self emitter].currentSpan);
    glUniform1f(mLocation.zoomScaleLoc, [self emitter].zoomScale);
    
    glVertexAttribPointer(mLocation.lifeSpanLoc, 1, GL_FLOAT, GL_FALSE, kRadialEmitterDataSize * sizeof(GLfloat), mEmitterData);
    glVertexAttribPointer(mLocation.startPositionLoc, 3, GL_FLOAT, GL_FALSE, kRadialEmitterDataSize * sizeof(GLfloat), &mEmitterData[1]);
    glVertexAttribPointer(mLocation.endPositionLoc, 3, GL_FLOAT, GL_FALSE, kRadialEmitterDataSize * sizeof(GLfloat), &mEmitterData[4]);
    
    glEnableVertexAttribArray(mLocation.lifeSpanLoc);
    glEnableVertexAttribArray(mLocation.endPositionLoc);
    glEnableVertexAttribArray(mLocation.startPositionLoc);
    
    glDrawArrays(GL_POINTS, 0, [self emitter].count);
    
    glDisableVertexAttribArray(mLocation.lifeSpanLoc);
    glDisableVertexAttribArray(mLocation.endPositionLoc);
    glDisableVertexAttribArray(mLocation.startPositionLoc);
}

@end