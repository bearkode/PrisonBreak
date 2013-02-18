/*
 *  PBProgramManager.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 4..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


@class PBProgram;


@interface PBProgramManager : NSObject
{
    PBProgram *mBundleProgram;
    PBProgram *mParticleProgram;
}


@property (nonatomic, readonly) PBProgram *bundleProgram;
@property (nonatomic, readonly) PBProgram *particleProgram;


+ (PBProgramManager *)sharedManager;


@end
