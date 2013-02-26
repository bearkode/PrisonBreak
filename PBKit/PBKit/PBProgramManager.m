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
#import "Shaders/PBBundleVertShader.h"
#import "Shaders/PBBundleFragShader.h"
#import "Shaders/PBParticleShader.h"


@implementation PBProgramManager


@synthesize program         = mProgram;
@synthesize particleProgram = mParticleProgram;


SYNTHESIZE_SINGLETON_CLASS(PBProgramManager, sharedManager)


- (id)init
{
    self = [super init];
    if (self)
    {
        mProgram = [[PBProgram alloc] init];
        [mProgram linkVertexSource:(GLbyte *)gBundleVShaderSource fragmentSource:(GLbyte *)gBundleFShaderSource];
        
        mParticleProgram = [[PBProgram alloc] init];
        [mParticleProgram linkVertexSource:(GLbyte *)gParticleVShaderSource fragmentSource:(GLbyte *)gParticleFShaderSource];
    }
    
    return self;
}


@end
