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


#define kParticleDataSize      7
#define kParticleDurationLimit 1.0


typedef struct {
    GLint projectionLoc;
    GLint playTimeLoc;
    GLint startPositionLoc;
    GLint endPositionLoc;
    GLint durationTimeLoc;
    GLint zoomScaleLoc;
    
} RadialParticleLocation;


@implementation RadialParticleProgram
{
    RadialParticleLocation mLocation;
    CGFloat   *mParticleData;
    CGFloat    mDurationTime;

    CGFloat    mSpeed;
    NSUInteger mCount;
    
    CompletionBlock mCompletionBlock;
}


@synthesize speed = mSpeed;
@synthesize count = mCount;


#pragma mark -




- (void)bindLocation
{
    mLocation.projectionLoc    = [self uniformLocation:@"aProjection"];
    mLocation.zoomScaleLoc     = [self uniformLocation:@"aZoomScale"];
    mLocation.durationTimeLoc  = [self uniformLocation:@"aDurationTime"];
    mLocation.playTimeLoc      = [self attributeLocation:@"aPlayTime"];
    mLocation.endPositionLoc   = [self attributeLocation:@"aEndPosition"];
    mLocation.startPositionLoc = [self attributeLocation:@"aStartPosition"];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        [self setType:kPBProgramCustom];
        [self setDelegate:self];
        [self linkVertexShaderFilename:@"RadialParticle" fragmentShaderFilename:@"RadialParticle"];
        [self bindLocation];
    }
    
    return self;
}


- (void)dealloc
{
    [mCompletionBlock release];
    
    if (mParticleData)
    {
        free(mParticleData);
    }
    
    [super dealloc];
}


#pragma mark -


- (void)setCompletionBlock:(CompletionBlock)aCallback
{
    if (mCompletionBlock)
    {
        [mCompletionBlock autorelease];
        mCompletionBlock = nil;
    }
    mCompletionBlock = [aCallback copy];
}


- (void)reset
{
    mDurationTime = 0;
    if (mParticleData)
    {
        free(mParticleData);
    }
    
    mParticleData  = malloc(sizeof(CGFloat) * (mCount * kParticleDataSize));
    
    for (NSInteger i = 0; i < mCount; i++)
    {
        float *sParticleData = &mParticleData[i * kParticleDataSize];
        
        (*sParticleData++) = ((float)(arc4random() % 10000) / 10000.0f);
        
        (*sParticleData++) = ((float)(arc4random() % 10000) / 5000.0f) - 1.0f;
        (*sParticleData++) = ((float)(arc4random() % 10000) / 5000.0f) - 1.0f;
        (*sParticleData++) = 1;
        
        (*sParticleData++) = 0.0;
        (*sParticleData++) = 0.0;
        (*sParticleData++) = 0.0;
    }
}


- (void)update
{
    mDurationTime += mSpeed;
    
    if (mDurationTime > kParticleDurationLimit)
    {
        if (mCompletionBlock)
        {
            mCompletionBlock();
            [mCompletionBlock release];
            mCompletionBlock = nil;
        }
    }
}


#pragma mark - PBProgramDelegate


- (void)pbProgramCustomDraw:(PBProgram *)aProgram
                        mvp:(PBMatrix)aProjection
                   vertices:(GLfloat *)aVertices
                 coordinate:(GLfloat *)aCoordinate
{
    glUniform1f(mLocation.durationTimeLoc, mDurationTime);
    glUniform1f(mLocation.zoomScaleLoc, 1.0f);
    
    glUniformMatrix4fv(mLocation.projectionLoc, 1, 0, &aProjection.m[0]);
    
    glVertexAttribPointer(mLocation.playTimeLoc, 1, GL_FLOAT, GL_FALSE, kParticleDataSize * sizeof(GLfloat), mParticleData);
    glVertexAttribPointer(mLocation.endPositionLoc, 3, GL_FLOAT, GL_FALSE, kParticleDataSize * sizeof(GLfloat), &mParticleData[1]);
    glVertexAttribPointer(mLocation.startPositionLoc, 3, GL_FLOAT, GL_FALSE, kParticleDataSize * sizeof(GLfloat), &mParticleData[4]);
    
    glEnableVertexAttribArray(mLocation.playTimeLoc);
    glEnableVertexAttribArray(mLocation.endPositionLoc);
    glEnableVertexAttribArray(mLocation.startPositionLoc);
    
    glDrawArrays(GL_POINTS, 0, mCount);
    
    glDisableVertexAttribArray(mLocation.playTimeLoc);
    glDisableVertexAttribArray(mLocation.endPositionLoc);
    glDisableVertexAttribArray(mLocation.startPositionLoc);
}


@end