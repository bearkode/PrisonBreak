/*
 *  PBKit.h
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012 PrisonBreak. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>

#import "PBVertices.h"
#import "PBMatrix.h"
#import "PBProgram.h"
#import "PBProgramManager.h"
#import "PBTransform.h"

#import "PBCamera.h"
#import "PBRenderer.h"

#import "PBCanvas.h"
#import "PBContext.h"
#import "PBLayer.h"
#import "PBRootLayer.h"
#import "PBColor.h"

#import "PBTexture.h"
#import "PBDynamicTexture.h"
#import "PBTextureLoadOperation.h"
#import "PBTextureLoader.h"
#import "PBTextureManager.h"

#import "PBSound.h"
#import "PBSoundBuffer.h"
#import "PBSoundData.h"
#import "PBSoundSource.h"
#import "PBSoundManager.h"
#import "PBSoundListener.h"
#import "PBMusicDetector.h"

#import "PBMesh.h"
#import "PBTileMesh.h"
#import "PBSprite.h"
#import "PBTileSprite.h"
#import "PBDrawingSprite.h"

#import "PBViewController.h"


#define PBDegreesToRadians(aDegrees) ((aDegrees) * M_PI / 180.0)
#define PBRadiansToDegrees(aRadians) ((aRadians) * 180.0 / M_PI)


#define PBBeginTimeCheck()           double __sCurrentTime = CACurrentMediaTime()
#define PBEndTimeCheck()             NSLog(@"time = %f", CACurrentMediaTime() - __sCurrentTime)