/*
 *  SampleTextureView.h
 *  PBKitTest
 *
 *  Created by sshanks on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
*/


#import <UIKit/UIKit.h>
#import <PBKit.h>


@interface SampleTextureView : PBView
{
    PBShaderProgram *mShader;
    PBRenderable    *mRenderable;
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
