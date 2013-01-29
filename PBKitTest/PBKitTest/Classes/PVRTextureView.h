/*
 *  PVRTextureView.h
 *  PBKitTest
 *
 *  Created by cgkim on 13. 1. 24..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#import "PBView.h"
#import <PBKit.h>


@interface PVRTextureView : PBView
{
    PBShaderProgram *mShader;
    PBTexture       *mTexture;
    CGFloat          mScale;
    CGFloat          mVerticeX;
    CGFloat          mVerticeY;
    CGFloat          mAngle;
}

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat verticeX;
@property (nonatomic, assign) CGFloat verticeY;
@property (nonatomic, assign) CGFloat angle;


@end
