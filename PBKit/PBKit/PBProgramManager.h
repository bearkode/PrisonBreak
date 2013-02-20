/*
 *  PBProgramManager.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 4..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


@class PBProgram;


typedef struct {
    GLint projectionLoc;
    GLint positionLoc;
    GLint texCoordLoc;
    GLint colorLoc;
    GLint selectionColorLoc;
    GLint selectModeLoc;
    GLint scaleLoc;
    GLint angleLoc;
    GLint translateLoc;
    GLint grayFilterLoc;
    GLint sepiaFilterLoc;
    GLint lumiFilterLoc;
    GLint blurFilterLoc;
} PBBundleLoc;


@interface PBProgramManager : NSObject
{
    PBProgram *mBundleProgram;
    PBProgram *mParticleProgram;
}


@property (nonatomic, readonly) PBProgram *bundleProgram;
@property (nonatomic, readonly) PBProgram *particleProgram;


+ (PBProgramManager *)sharedManager;


@end
