//
//  PBProgramEffect.h
//  PBKit
//
//  Created by sshanks on 13. 7. 8..
//  Copyright (c) 2013년 NHN. All rights reserved.
//

#ifndef PBKit_PBProgramEffect_h
#define PBKit_PBProgramEffect_h


@class PBProgram;


typedef NS_ENUM(NSUInteger, PBProgramType)
{
    kPBProgramBasic      = 0,
    kPBProgramSelection,
    
    kPBProgramEffect,
    kPBProgramEffectGray,
    kPBProgramEffectSepia,
    kPBProgramEffectBlur,
    kPBProgramLuminance,
    
    kPBProgramParticle,
};


#pragma mark - PBProgramEffectDelegate;


@protocol PBProgramEffectDelegate <NSObject> // for PBEffectNode

@optional

// for kPBProgramCustom. mvp, vertices and coordinates are already applied.
- (void)pbProgramWillEffectDraw:(PBProgram *)aProgram;

// for kPBProgramCustomWithMesh. Direct mvp, vertices and projection must apply.
- (void)pbProgramWillParticleDraw:(PBProgram *)aProgram;


@end



#endif
