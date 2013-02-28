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
#import "Shaders/PBVertShader.h"
#import "Shaders/PBFragShader.h"
#import "Shaders/PBSelectFragShader.h"
#import "Shaders/PBParticleShader.h"


static PBProgram *gCurrentProgram = nil;


@implementation PBProgramManager
{
    PBProgram *mProgram;
    PBProgram *mSelectionProgram;
    PBProgram *mParticleProgram;
}


@synthesize program          = mProgram;
@synthesize selectionProgram = mSelectionProgram;
@synthesize particleProgram  = mParticleProgram;


SYNTHESIZE_SINGLETON_CLASS(PBProgramManager, sharedManager)



+ (void)setCurrentProgram:(PBProgram *)aProgram
{
    gCurrentProgram = aProgram;
}


+ (PBProgram *)currentProgram
{
    return gCurrentProgram;
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mProgram = [[PBProgram alloc] init];
        [mProgram linkVertexSource:(GLbyte *)gVertShaderSource fragmentSource:(GLbyte *)gFragShaderSource];
        
        mSelectionProgram = [[PBProgram alloc] init];
        [mSelectionProgram linkVertexSource:(GLbyte *)gVertShaderSource fragmentSource:(GLbyte *)gSelectFragShaderSource];
        
        mParticleProgram = [[PBProgram alloc] init];
        [mParticleProgram linkVertexSource:(GLbyte *)gParticleVShaderSource fragmentSource:(GLbyte *)gParticleFShaderSource];
    }
    
    return self;
}


@end
