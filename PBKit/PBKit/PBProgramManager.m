/*
 *  PBProgramManager.m
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 4..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <OpenGLES/ES2/gl.h>
#import "PBProgramManager.h"
#import "PBProgram.h"
#import "PBObjCUtil.h"
#import "Shaders/PBVertShader.h"
#import "Shaders/PBTextureFragShader.h"
#import "Shaders/PBNormalFragShader.h"
#import "Shaders/PBColorFragShader.h"
#import "Shaders/PBSelectFragShader.h"
#import "Shaders/PBGrayscaleFragShader.h"
#import "Shaders/PBSepiaFragShader.h"
#import "Shaders/PBBlurFragShader.h"


static PBProgram *gCurrentProgram = nil;


@implementation PBProgramManager
{
    PBProgram *mProgram;
    PBProgram *mNormalProgram;
    PBProgram *mColorProgram;
    PBProgram *mSelectionProgram;
    PBProgram *mGrayscaleProgram;
    PBProgram *mSepiaProgram;
    PBProgram *mBlurProgram;
}


@synthesize program          = mProgram;
@synthesize normalProgram    = mNormalProgram;
@synthesize colorProgram     = mColorProgram;
@synthesize selectionProgram = mSelectionProgram;
@synthesize grayscaleProgram = mGrayscaleProgram;
@synthesize sepiaProgram     = mSepiaProgram;
@synthesize blurProgram      = mBlurProgram;


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
        [mProgram setMode:kPBProgramModeDefault];
        [mProgram linkVertexSource:(GLbyte *)gVertShaderSource fragmentSource:(GLbyte *)gTextureFragShaderSource];
        
        mNormalProgram = [[PBProgram alloc] init];
        [mNormalProgram setMode:kPBProgramModeDefault];
        [mNormalProgram linkVertexSource:(GLbyte *)gVertShaderSource fragmentSource:(GLbyte *)gNormalFragShaderSource];
        
        mColorProgram = [[PBProgram alloc] init];
        [mColorProgram setMode:kPBProgramModeDefault];
        [mColorProgram linkVertexSource:(GLbyte *)gVertShaderSource fragmentSource:(GLbyte *)gColorFragShaderSource];
        
        mSelectionProgram = [[PBProgram alloc] init];
        [mSelectionProgram setMode:kPBProgramModeSelection];
        [mSelectionProgram linkVertexSource:(GLbyte *)gVertShaderSource fragmentSource:(GLbyte *)gSelectFragShaderSource];
        
        mGrayscaleProgram = [[PBProgram alloc] init];
        [mGrayscaleProgram setMode:kPBProgramModeColorGrayScale];
        [mGrayscaleProgram linkVertexSource:(GLbyte *)gVertShaderSource fragmentSource:(GLbyte *)gGrayscaleFragShaderSource];
        
        mSepiaProgram = [[PBProgram alloc] init];
        [mSepiaProgram setMode:kPBProgramModeColorSepia];
        [mSepiaProgram linkVertexSource:(GLbyte *)gVertShaderSource fragmentSource:(GLbyte *)gSepiaFragShaderSource];
        
        mBlurProgram = [[PBProgram alloc] init];
        [mBlurProgram setMode:kPBProgramModeColorBlur];
        [mBlurProgram linkVertexSource:(GLbyte *)gVertShaderSource fragmentSource:(GLbyte *)gBlurFragShaderSource];
    }
    
    return self;
}


@end
