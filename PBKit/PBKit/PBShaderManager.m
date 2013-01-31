/*
 *  PBShaderManager.m
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 4..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#import "PBKit.h"
#import "PBObjCUtil.h"
#import "Shaders/PBTextureShader.h"
#import "Shaders/PBParticleShader.h"


@implementation PBShaderManager


@synthesize textureShader  = mTextureShader;
@synthesize particleShader = mParticleShader;


SYNTHESIZE_SINGLETON_CLASS(PBShaderManager, sharedManager)


- (id)init
{
    self = [super init];
    if (self)
    {
        mTextureShader = [[PBShaderProgram alloc] init];
        [mTextureShader linkShaderVertexSource:(GLbyte *)gTextureVShaderSource fragmentSource:(GLbyte *)gTextureFShaderSource];
        
        mParticleShader = [[PBShaderProgram alloc] init];
        [mParticleShader linkShaderVertexSource:(GLbyte *)gParticleVShaderSource fragmentSource:(GLbyte *)gParticleFShaderSource];
    }
    
    return self;
}


@end
