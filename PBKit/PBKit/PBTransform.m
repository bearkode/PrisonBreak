/*
 *  PBTransform.m
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 28..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "PBKit.h"


@implementation PBTransform


@synthesize angle     = mAngle;
@synthesize scale     = mScale;
@synthesize translate = mTranslate;


#pragma mark -


+ (PBMatrix4)multiplyWithMatrixA:(PBMatrix4)aMatrixA matrixB:(PBMatrix4)aMatrixB
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


+ (PBMatrix4)multiplyOrthoMatrix:(PBMatrix4)aMatrix left:(GLfloat)aLeft right:(GLfloat)aRight bottom:(GLfloat)aBottom top:(GLfloat)aTop near:(GLfloat)aNear far:(GLfloat)aFar
{
    PBMatrix4 sMatrix;
    PBMatrix4 sOrthoMatrix = PBMatrix4Identity;

    float sDeltaX = aRight - aLeft;
    float sDeltaY = aTop   - aBottom;
    float sDeltaZ = aFar   - aNear;
    
    if ((sDeltaX == 0.0f) || (sDeltaY == 0.0f) || (sDeltaZ == 0.0f))
    {
        return PBMatrix4Identity;
    }
    
    sOrthoMatrix.m[0][0] =  2.0f / sDeltaX;
    sOrthoMatrix.m[1][1] =  2.0f / sDeltaY;
    sOrthoMatrix.m[2][2] = -2.0f / sDeltaZ;
    sOrthoMatrix.m[3][0] = -(aRight + aLeft) / sDeltaX;
    sOrthoMatrix.m[3][1] = -(aTop + aBottom) / sDeltaY;
    sOrthoMatrix.m[3][2] = -(aNear + aFar) / sDeltaZ;
    
    sMatrix = [PBTransform multiplyWithMatrixA:sOrthoMatrix matrixB:aMatrix];
    return sMatrix;
}


+ (PBMatrix4)multiplyTranslateMatrix:(PBMatrix4)aMatrix translate:(PBVertex3)aTranslate
{
    PBMatrix4 sModelMatrix = aMatrix;
    
    sModelMatrix.m[3][0] += (sModelMatrix.m[0][0] * aTranslate.x + sModelMatrix.m[1][0] * aTranslate.y + sModelMatrix.m[2][0] * aTranslate.z);
    sModelMatrix.m[3][1] += (sModelMatrix.m[0][1] * aTranslate.x + sModelMatrix.m[1][1] * aTranslate.y + sModelMatrix.m[2][1] * aTranslate.z);
    sModelMatrix.m[3][2] += (sModelMatrix.m[0][2] * aTranslate.x + sModelMatrix.m[1][2] * aTranslate.y + sModelMatrix.m[2][2] * aTranslate.z);
    sModelMatrix.m[3][3] += (sModelMatrix.m[0][3] * aTranslate.x + sModelMatrix.m[1][3] * aTranslate.y + sModelMatrix.m[2][3] * aTranslate.z);
    
    return sModelMatrix;
}


+ (PBMatrix4)multiplyRotateMatrix:(PBMatrix4)aMatrix angle:(PBVertex3)aAngle
{
    PBMatrix4 sRotateMatrix = PBMatrix4Identity;
    PBMatrix4 sMatrix       = [PBTransform multiplyWithMatrixA:sRotateMatrix matrixB:aMatrix];;
    CGFloat   sRadian       = 0.0f;
    CGFloat   sSin          = 0.0f;
    CGFloat   sCos          = 0.0f;
    
    if(aAngle.x != 0)
    {
        sRotateMatrix = PBMatrix4Identity;
        sRadian = PBDegreesToRadians(aAngle.x);
        sSin = sinf(sRadian);
        sCos = cosf(sRadian);
        
        sRotateMatrix.m[1][1] = sCos;
        sRotateMatrix.m[1][2] = -sSin;
        sRotateMatrix.m[2][1] = sSin;
        sRotateMatrix.m[2][2] = sCos;

        sMatrix = [PBTransform multiplyWithMatrixA:sRotateMatrix matrixB:aMatrix];
        aMatrix = sMatrix;
    }
    
    if(aAngle.y != 0)
    {
        sRotateMatrix = PBMatrix4Identity;
        sRadian = PBDegreesToRadians(aAngle.y);
        sSin = sinf(sRadian);
        sCos = cosf(sRadian);
        
        sRotateMatrix.m[0][0] = sCos;
        sRotateMatrix.m[0][2] = sSin;
        sRotateMatrix.m[2][0] = -sSin;
        sRotateMatrix.m[2][2] = sCos;
        
        sMatrix = [PBTransform multiplyWithMatrixA:sRotateMatrix matrixB:aMatrix];
        aMatrix = sMatrix;
    }
    
    if(aAngle.z != 0)
    {
        sRotateMatrix = PBMatrix4Identity;
        sRadian = PBDegreesToRadians(aAngle.z);
        sSin = sinf(sRadian);
        sCos = cosf(sRadian);
        
        sRotateMatrix.m[0][0] = sCos;
        sRotateMatrix.m[0][1] = -sSin;
        sRotateMatrix.m[1][0] = sSin;
        sRotateMatrix.m[1][1] = sCos;
        
        sMatrix = [PBTransform multiplyWithMatrixA:sRotateMatrix matrixB:aMatrix];
        aMatrix = sMatrix;
    }
    
    return sMatrix;
}


+ (PBMatrix4)multiplyScaleMatrix:(PBMatrix4)aMatrix scale:(CGFloat)aScale
{
    PBMatrix4 sMatrix;
    PBMatrix4 sScaleMatrix = PBMatrix4Identity;

    sScaleMatrix.m[0][0] *= aScale;
    sScaleMatrix.m[0][1] *= aScale;
    sScaleMatrix.m[0][2] *= aScale;
    sScaleMatrix.m[0][3] *= aScale;

    sScaleMatrix.m[1][0] *= aScale;
    sScaleMatrix.m[1][1] *= aScale;
    sScaleMatrix.m[1][2] *= aScale;
    sScaleMatrix.m[1][3] *= aScale;
    
    sScaleMatrix.m[2][0] *= aScale;
    sScaleMatrix.m[2][1] *= aScale;
    sScaleMatrix.m[2][2] *= aScale;
    sScaleMatrix.m[2][3] *= aScale;

    sMatrix = [PBTransform multiplyWithMatrixA:sScaleMatrix matrixB:aMatrix];
    return sMatrix;
}


+ (PBMatrix4)multiplyFrustumMatrix:(PBMatrix4)aMatrix left:(CGFloat)aLeft right:(CGFloat)aRight bottom:(CGFloat)aBottom top:(CGFloat)aTop nearZ:(CGFloat)aNearZ farZ:(CGFloat)aFarZ
{
    PBMatrix4 sMatrix;
    PBMatrix4 sFrustMatrix = PBMatrix4Identity;

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
    
    sMatrix = [PBTransform multiplyWithMatrixA:sFrustMatrix matrixB:aMatrix];
    
    return sMatrix;
}


#pragma mark -


- (void)assignTransform:(PBTransform *)aTransform
{
    mTranslate = [aTransform translate];
    mAngle     = [aTransform angle];
    mScale     = [aTransform scale];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mScale     = 1.0f;
        mTranslate = PBVertex3Make(0, 0, 0);
        mAngle     = PBVertex3Make(0, 0, 0);
    }
    
    return self;
}


@end
