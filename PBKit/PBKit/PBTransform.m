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


@implementation PBTransform


@synthesize matrix    = mMatrix;
@synthesize angle     = mAngle;
@synthesize translate = mTranslate;


- (PBMatrix4)multiplyWithSrcA:(PBMatrix4)aMatrixA srcB:(PBMatrix4)aMatrixB
{
    PBMatrix4 sMatrix;
	for (NSInteger i = 0; i < 4; i++)
	{
		sMatrix.m[i][0] = (aMatrixA.m[i][0] * aMatrixB.m[0][0]) + (aMatrixA.m[i][1] * aMatrixB.m[1][0]) + (aMatrixA.m[i][2] * aMatrixB.m[2][0]) + (aMatrixA.m[i][3] * aMatrixB.m[3][0]);
		sMatrix.m[i][1] = (aMatrixA.m[i][0] * aMatrixB.m[0][1]) + (aMatrixA.m[i][1] * aMatrixB.m[1][1]) + (aMatrixA.m[i][2] * aMatrixB.m[2][1]) + (aMatrixA.m[i][3] * aMatrixB.m[3][1]);
		sMatrix.m[i][2] = (aMatrixA.m[i][0] * aMatrixB.m[0][2]) + (aMatrixA.m[i][1] * aMatrixB.m[1][2]) + (aMatrixA.m[i][2] * aMatrixB.m[2][2]) + (aMatrixA.m[i][3] * aMatrixB.m[3][2]);
		sMatrix.m[i][3] = (aMatrixA.m[i][0] * aMatrixB.m[0][3]) + (aMatrixA.m[i][1] * aMatrixB.m[1][3]) + (aMatrixA.m[i][2] * aMatrixB.m[2][3]) + (aMatrixA.m[i][3] * aMatrixB.m[3][3]);
	}
    
    return sMatrix;
}


- (PBMatrix4)applyTranslate:(PBMatrix4)aMatrix
{
    PBMatrix4 sModelMatrix = aMatrix;
    
    sModelMatrix.m[3][0] += (sModelMatrix.m[0][0] * mTranslate.x + sModelMatrix.m[1][0] * mTranslate.y + sModelMatrix.m[2][0] * mTranslate.z);
    sModelMatrix.m[3][1] += (sModelMatrix.m[0][1] * mTranslate.x + sModelMatrix.m[1][1] * mTranslate.y + sModelMatrix.m[2][1] * mTranslate.z);
    sModelMatrix.m[3][2] += (sModelMatrix.m[0][2] * mTranslate.x + sModelMatrix.m[1][2] * mTranslate.y + sModelMatrix.m[2][2] * mTranslate.z);
    sModelMatrix.m[3][3] += (sModelMatrix.m[0][3] * mTranslate.x + sModelMatrix.m[1][3] * mTranslate.y + sModelMatrix.m[2][3] * mTranslate.z);
    
    return sModelMatrix;
}


- (PBMatrix4)applyRotation:(PBMatrix4)aMatrix
{
    PBMatrix4 sDestMatrix;
    PBMatrix4 sRotationMatrix;
    
    CGFloat aRadian = PBDegreesToRadians(mAngle);
    CGFloat sSin = sinf(aRadian);
    CGFloat sCos = cosf(aRadian);

    sRotationMatrix.m[0][0] = sCos;
    sRotationMatrix.m[0][1] = -sSin;
    sRotationMatrix.m[0][2] = 0.0f;
    sRotationMatrix.m[0][3] = 0.0f;
    
    sRotationMatrix.m[1][0] = sSin;
    sRotationMatrix.m[1][1] = sCos;
    sRotationMatrix.m[1][2] = 0;
    sRotationMatrix.m[1][3] = 0.0f;
    
    sRotationMatrix.m[2][0] = 0.0f;
    sRotationMatrix.m[2][1] = 0.0f;
    sRotationMatrix.m[2][2] = sCos;
    sRotationMatrix.m[2][3] = 0.0f;
    
    sRotationMatrix.m[3][0] = 0.0f;
    sRotationMatrix.m[3][1] = 0.0f;
    sRotationMatrix.m[3][2] = 0.0f;
    sRotationMatrix.m[3][3] = 1.0f;
    
    sDestMatrix = [self multiplyWithSrcA:sRotationMatrix srcB:aMatrix];    
    return sDestMatrix;

    //    mMatrix =
    //    {
    //        sCos, sSin, sSin, 0.0f,
    //        -sSin, sCos, 0.0f, 0.0f,
    //        0.0f, 0.0f, -sCos, 0.0f,
    //        0.0f, 0.0f, 0.0f, 1.0f
    //    };

}


- (PBMatrix4)applyFrustum:(PBMatrix4)aMatrix left:(CGFloat)aLeft right:(CGFloat)aRight top:(CGFloat)aTop bottom:(CGFloat)aBottom nearZ:(CGFloat)aNearZ farZ:(CGFloat)aFarZ
{
    PBMatrix4 sDestMatrix;
    PBMatrix4 sFrustMatrix;

    CGFloat sDeltaX = aRight - aLeft;
    CGFloat sDeltaY = aTop   - aBottom;
    CGFloat sDeltaZ = aFarZ  - aNearZ;
    
    if ((aNearZ <= 0.0f) || (aFarZ <= 0.0f) || (sDeltaX <= 0.0f) || (sDeltaY <= 0.0f) || (sDeltaZ <= 0.0f))
    {
        return PBMatrix4Identity;
    }
    
    sFrustMatrix.m[0][0] = 2.0f * aNearZ / sDeltaX;
    sFrustMatrix.m[0][1] = sFrustMatrix.m[0][2] = sFrustMatrix.m[0][3] = 0.0f;
    
    sFrustMatrix.m[1][1] = 2.0f * aNearZ / sDeltaY;
    sFrustMatrix.m[1][0] = sFrustMatrix.m[1][2] = sFrustMatrix.m[1][3] = 0.0f;
    
    sFrustMatrix.m[2][0] = (aRight + aLeft)  / sDeltaX;
    sFrustMatrix.m[2][1] = (aTop + aBottom)  / sDeltaY;
    sFrustMatrix.m[2][2] = -(aNearZ + aFarZ) / sDeltaZ;
    sFrustMatrix.m[2][3] = -1.0f;
    
    sFrustMatrix.m[3][2] = -2.0f * aNearZ * aFarZ / sDeltaZ;
    sFrustMatrix.m[3][0] = sFrustMatrix.m[3][1] = sFrustMatrix.m[3][3] = 0.0f;
    
    sDestMatrix = [self multiplyWithSrcA:sFrustMatrix srcB:aMatrix];
    
    return sDestMatrix;
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mMatrix = PBMatrix4Identity;
    }
    
    return self;
}


@end
