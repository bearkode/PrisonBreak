/*
 *  PBProgramEffect.h
 *  PBKit
 *
 *  Created by camelkode on 13. 7. 8..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#ifndef PBKit_PBProgramEffect_h
#define PBKit_PBProgramEffect_h


@class PBProgram;


typedef NS_ENUM(NSUInteger, PBProgramMode)
{
    kPBProgramModeDefault = 0,    // default
    kPBProgramModeSelection,      // for selection mode
    kPBProgramModeColorGrayScale, // change fragment color to grayscale
    kPBProgramModeColorSepia,     // change fragment color to sepia
    kPBProgramModeColorBlur,      // change fragment color to blur

    kPBProgramModeSemiauto,       // glDraw... and handling position, texCoord.
    kPBProgramModeManual,         // direct write to drawing code
};


#pragma mark - PBProgramDrawDelegate;


@protocol PBProgramDrawDelegate <NSObject>

@optional

- (void)pbProgramWillSemiautoDraw:(PBProgram *)aProgram;
// for kPBProgramModeSemiautomatic.

- (void)pbProgramWillManualDraw:(PBProgram *)aProgram;
// for kPBProgramModeManual.

@end



#endif
