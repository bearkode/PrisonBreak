/*
 *  PBShaderManager.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 4..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


@class PBShaderProgram;


@interface PBShaderManager : NSObject
{
    PBShaderProgram *mTextureShader;
    PBShaderProgram *mParticleShader;
}


@property (nonatomic, readonly) PBShaderProgram *textureShader;
@property (nonatomic, readonly) PBShaderProgram *particleShader;


+ (PBShaderManager *)sharedManager;


@end
