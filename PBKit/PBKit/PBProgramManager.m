/*
 *  PBProgramManager.m
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


@implementation PBProgramManager


@synthesize textureProgram  = mTextureProgram;
@synthesize particleProgram = mParticleProgram;


SYNTHESIZE_SINGLETON_CLASS(PBProgramManager, sharedManager)


- (id)init
{
    self = [super init];
    if (self)
    {
        mTextureProgram = [[PBProgram alloc] init];
        [mTextureProgram linkVertexSource:(GLbyte *)gTextureVShaderSource fragmentSource:(GLbyte *)gTextureFShaderSource];
        
        mParticleProgram = [[PBProgram alloc] init];
        [mParticleProgram linkVertexSource:(GLbyte *)gParticleVShaderSource fragmentSource:(GLbyte *)gParticleFShaderSource];
    }
    
    return self;
}


@end
