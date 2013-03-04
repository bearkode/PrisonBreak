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
#import "Shaders/PBGrayScaleFragShader.h"


static PBProgram *gCurrentProgram = nil;


@implementation PBProgramManager
{
    PBProgram *mProgram;
    PBProgram *mSelectionProgram;
    PBProgram *mGrayscaleProgram;
}


@synthesize program          = mProgram;
@synthesize selectionProgram = mSelectionProgram;
@synthesize grayscaleProgram = mGrayscaleProgram;


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
        
        mGrayscaleProgram = [[PBProgram alloc] init];
        [mGrayscaleProgram linkVertexSource:(GLbyte *)gVertShaderSource fragmentSource:(GLbyte *)gGrayScaleFragShaderSource];
    }
    
    return self;
}


@end
