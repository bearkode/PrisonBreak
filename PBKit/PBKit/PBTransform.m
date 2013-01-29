/*
 *  PBTransform.m
 *  PBKit
 *
 *  Created by sshanks on 13. 1. 28..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "PBKit.h"


#define PBDegreesToRadians(aDegrees) ((aDegrees) * M_PI / 180.0)
#define PBRadiansToDegrees(aRadians) ((aRadians) * 180.0 / M_PI)


const PBMatrix4 PBMatrix4Identity = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 };


@implementation PBTransform


@synthesize matrix = mMatrix;


- (void)setAngle:(CGFloat)aAngle
{
    mMatrix = PBMatrix4Identity;
    
    CGFloat aRatian = PBDegreesToRadians(aAngle);
    
    float sCos = cosf(aRatian);
    float sSin = sinf(aRatian);
    
    mMatrix.m[0] = sCos;
    mMatrix.m[1] = sSin;
    mMatrix.m[2] = sSin;
    mMatrix.m[4] = -sSin;
    mMatrix.m[5] = sCos;
    mMatrix.m[10] = -sCos;
    mMatrix.m[15] = 1.0f;
    
//    mMatrix =
//    {
//        sCos, sSin, sSin, 0.0f,
//        -sSin, sCos, 0.0f, 0.0f,
//        0.0f, 0.0f, -sCos, 0.0f,
//        0.0f, 0.0f, 0.0f, 1.0f
//    };
}


@end
