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


#pragma mark -


@property (nonatomic, readonly) PBProgram *program;
@property (nonatomic, readonly) PBProgram *selectionProgram;
@property (nonatomic, readonly) PBProgram *particleProgram;


#pragma mark -


+ (PBProgramManager *)sharedManager;

+ (void)setCurrentProgram:(PBProgram *)aProgram;
+ (PBProgram *)currentProgram;


@end
