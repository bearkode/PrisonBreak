/*
 *  SampleTextureView.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 21..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
*/


#import <UIKit/UIKit.h>
#import <PBKit.h>


@interface SampleTextureView : PBView <PBDisplayDelegate>
{
    PBShaderProgram *mShader;
    PBRenderable    *mRenderable1;
    PBRenderable    *mRenderable2;
    PBRenderable    *mRenderable3;
    CGFloat          mScale;
    CGFloat          mAngle;
}


@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat angle;


@end
