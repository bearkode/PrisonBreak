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
#import "Shaders/PBGrayscaleFragShader.h"
#import "Shaders/PBSepiaFragShader.h"
#import "Shaders/PBBlurFragShader.h"
#import "Shaders/PBLuminanceFragShader.h"


static PBProgram *gCurrentProgram = nil;


@implementation PBProgramManager
{
    PBProgram *mProgram;
    PBProgram *mSelectionProgram;
    PBProgram *mGrayscaleProgram;
    PBProgram *mSepiaProgram;
    PBProgram *mBlurProgram;
    PBProgram *mLuminanceProgram;
}


@synthesize program          = mProgram;
@synthesize selectionProgram = mSelectionProgram;
@synthesize grayscaleProgram = mGrayscaleProgram;
@synthesize sepiaProgram     = mSepiaProgram;
@synthesize blurProgram      = mBlurProgram;
@synthesize luminanceProgram = mLuminanceProgram;


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
        [mGrayscaleProgram linkVertexSource:(GLbyte *)gVertShaderSource fragmentSource:(GLbyte *)gGrayscaleFragShaderSource];
        
        mSepiaProgram = [[PBProgram alloc] init];
        [mSepiaProgram linkVertexSource:(GLbyte *)gVertShaderSource fragmentSource:(GLbyte *)gSepiaFragShaderSource];
        
        mBlurProgram = [[PBProgram alloc] init];
        [mBlurProgram linkVertexSource:(GLbyte *)gVertShaderSource fragmentSource:(GLbyte *)gBlurFragShaderSource];
        
        mLuminanceProgram = [[PBProgram alloc] init];
        [mLuminanceProgram linkVertexSource:(GLbyte *)gVertShaderSource fragmentSource:(GLbyte *)gLuminanceFragShaderSource];
    }
    
    return self;
}


@end
