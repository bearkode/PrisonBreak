/*
 *  PBProgramManager.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 4..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


typedef enum
{
    kPBProgram          = 0,
    kPBProgramGray      = 1 << 0,
    kPBProgramSepia     = 1 << 1,
    kPBProgramBlur      = 1 << 2,
    kPBProgramLuminance = 1 << 3,
} kPBProgramType;


@class PBProgram;


@interface PBProgramManager : NSObject


#pragma mark -


@property (nonatomic, readonly) PBProgram *program;
@property (nonatomic, readonly) PBProgram *selectionProgram;
@property (nonatomic, readonly) PBProgram *grayscaleProgram;
@property (nonatomic, readonly) PBProgram *sepiaProgram;
@property (nonatomic, readonly) PBProgram *blurProgram;
@property (nonatomic, readonly) PBProgram *luminanceProgram;


#pragma mark -


+ (PBProgramManager *)sharedManager;

+ (void)setCurrentProgram:(PBProgram *)aProgram;
+ (PBProgram *)currentProgram;


+ (PBProgram *)programForType:(kPBProgramType)aType;


@end
