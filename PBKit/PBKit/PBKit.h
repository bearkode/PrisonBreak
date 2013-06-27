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

/*  Internal  */
#import "PBVertices.h"
#import "PBMatrix.h"
#import "PBProgram.h"
#import "PBProgramManager.h"
#import "PBTransform.h"
#import "PBColor.h"
#import "PBMesh.h"
#import "PBTileMesh.h"
#import "PBRenderer.h"
#import "PBContext.h"

/*  View & Camera  */
#import "PBCanvas.h"
#import "PBCamera.h"

/*  Node  */
#import "PBNode.h"
#import "PBScene.h"
#import "PBSpriteNode.h"
#import "PBSpriteNode+TileAddition.h"
#import "PBSpriteNode+DynamicAddition.h"

/*  Texture  */
#import "PBTexture.h"
#import "PBDynamicTexture.h"
#import "PBTextureLoadOperation.h"
#import "PBTextureLoader.h"
#import "PBTextureManager.h"

/*  Util  */
#import "PBViewController.h"

/*  Sound  */
#import "PBSound.h"
#import "PBSoundBuffer.h"
#import "PBSoundData.h"
#import "PBSoundSource.h"
#import "PBSoundManager.h"
#import "PBSoundListener.h"
#import "PBMusicDetector.h"


/*  Macro  */
#define PBDegreesToRadians(aDegrees) ((aDegrees) * M_PI / 180.0)
#define PBRadiansToDegrees(aRadians) ((aRadians) * 180.0 / M_PI)


#define PBBeginTimeCheck()           double __sCurrentTime = CACurrentMediaTime()
#define PBEndTimeCheck()             NSLog(@"time = %f", CACurrentMediaTime() - __sCurrentTime)

