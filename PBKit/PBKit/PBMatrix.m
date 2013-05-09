/*
 *  PBMatrix.m
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 26..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBMatrix.h"
#import "PBKit.h"


static inline PBMatrix PBMultiplyMatrix(PBMatrix aSrcA, PBMatrix aSrcB)
{
    PBMatrix sMatrix;

    sMatrix.m[0][0] = (aSrcA.m[0][0] * aSrcB.m[0][0]) + (aSrcA.m[0][1] * aSrcB.m[1][0]) + (aSrcA.m[0][2] * aSrcB.m[2][0]) + (aSrcA.m[0][3] * aSrcB.m[3][0]);
    sMatrix.m[0][1] = (aSrcA.m[0][0] * aSrcB.m[0][1]) + (aSrcA.m[0][1] * aSrcB.m[1][1]) + (aSrcA.m[0][2] * aSrcB.m[2][1]) + (aSrcA.m[0][3] * aSrcB.m[3][1]);
    sMatrix.m[0][2] = (aSrcA.m[0][0] * aSrcB.m[0][2]) + (aSrcA.m[0][1] * aSrcB.m[1][2]) + (aSrcA.m[0][2] * aSrcB.m[2][2]) + (aSrcA.m[0][3] * aSrcB.m[3][2]);
    sMatrix.m[0][3] = (aSrcA.m[0][0] * aSrcB.m[0][3]) + (aSrcA.m[0][1] * aSrcB.m[1][3]) + (aSrcA.m[0][2] * aSrcB.m[2][3]) + (aSrcA.m[0][3] * aSrcB.m[3][3]);

    sMatrix.m[1][0] = (aSrcA.m[1][0] * aSrcB.m[0][0]) + (aSrcA.m[1][1] * aSrcB.m[1][0]) + (aSrcA.m[1][2] * aSrcB.m[2][0]) + (aSrcA.m[1][3] * aSrcB.m[3][0]);
    sMatrix.m[1][1] = (aSrcA.m[1][0] * aSrcB.m[0][1]) + (aSrcA.m[1][1] * aSrcB.m[1][1]) + (aSrcA.m[1][2] * aSrcB.m[2][1]) + (aSrcA.m[1][3] * aSrcB.m[3][1]);
    sMatrix.m[1][2] = (aSrcA.m[1][0] * aSrcB.m[0][2]) + (aSrcA.m[1][1] * aSrcB.m[1][2]) + (aSrcA.m[1][2] * aSrcB.m[2][2]) + (aSrcA.m[1][3] * aSrcB.m[3][2]);
    sMatrix.m[1][3] = (aSrcA.m[1][0] * aSrcB.m[0][3]) + (aSrcA.m[1][1] * aSrcB.m[1][3]) + (aSrcA.m[1][2] * aSrcB.m[2][3]) + (aSrcA.m[1][3] * aSrcB.m[3][3]);

    sMatrix.m[2][0] = (aSrcA.m[2][0] * aSrcB.m[0][0]) + (aSrcA.m[2][1] * aSrcB.m[1][0]) + (aSrcA.m[2][2] * aSrcB.m[2][0]) + (aSrcA.m[2][3] * aSrcB.m[3][0]);
    sMatrix.m[2][1] = (aSrcA.m[2][0] * aSrcB.m[0][1]) + (aSrcA.m[2][1] * aSrcB.m[1][1]) + (aSrcA.m[2][2] * aSrcB.m[2][1]) + (aSrcA.m[2][3] * aSrcB.m[3][1]);
    sMatrix.m[2][2] = (aSrcA.m[2][0] * aSrcB.m[0][2]) + (aSrcA.m[2][1] * aSrcB.m[1][2]) + (aSrcA.m[2][2] * aSrcB.m[2][2]) + (aSrcA.m[2][3] * aSrcB.m[3][2]);
    sMatrix.m[2][3] = (aSrcA.m[2][0] * aSrcB.m[0][3]) + (aSrcA.m[2][1] * aSrcB.m[1][3]) + (aSrcA.m[2][2] * aSrcB.m[2][3]) + (aSrcA.m[2][3] * aSrcB.m[3][3]);

    sMatrix.m[3][0] = (aSrcA.m[3][0] * aSrcB.m[0][0]) + (aSrcA.m[3][1] * aSrcB.m[1][0]) + (aSrcA.m[3][2] * aSrcB.m[2][0]) + (aSrcA.m[3][3] * aSrcB.m[3][0]);
    sMatrix.m[3][1] = (aSrcA.m[3][0] * aSrcB.m[0][1]) + (aSrcA.m[3][1] * aSrcB.m[1][1]) + (aSrcA.m[3][2] * aSrcB.m[2][1]) + (aSrcA.m[3][3] * aSrcB.m[3][1]);
    sMatrix.m[3][2] = (aSrcA.m[3][0] * aSrcB.m[0][2]) + (aSrcA.m[3][1] * aSrcB.m[1][2]) + (aSrcA.m[3][2] * aSrcB.m[2][2]) + (aSrcA.m[3][3] * aSrcB.m[3][2]);
    sMatrix.m[3][3] = (aSrcA.m[3][0] * aSrcB.m[0][3]) + (aSrcA.m[3][1] * aSrcB.m[1][3]) + (aSrcA.m[3][2] * aSrcB.m[2][3]) + (aSrcA.m[3][3] * aSrcB.m[3][3]);
    
    return sMatrix;
}


@implementation PBMatrixOperator


+ (NSString *)description:(PBMatrix)aMatrix
{
	NSMutableString* desc = [NSMutableString stringWithCapacity: 200];
	[desc appendFormat: @"\n\t[%.3f, ", aMatrix.m[0][0]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[1][0]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[2][0]];
	[desc appendFormat: @"%.3f,\n\t ", aMatrix.m[3][0]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[0][1]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[1][1]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[2][1]];
	[desc appendFormat: @"%.3f,\n\t ", aMatrix.m[3][1]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[0][2]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[1][2]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[2][2]];
	[desc appendFormat: @"%.3f,\n\t ", aMatrix.m[3][2]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[0][3]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[1][3]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[2][3]];
	[desc appendFormat: @"%.3f]", aMatrix.m[3][3]];
	return desc;
}

+ (PBMatrix)multiplyMatrixA:(PBMatrix)aSrcA matrixB:(PBMatrix)aSrcB
{
    return PBMultiplyMatrix(aSrcA, aSrcB);
}


+ (PBMatrix)orthoMatrix:(PBMatrix)aSrc left:(GLfloat)aLeft right:(GLfloat)aRight bottom:(GLfloat)aBottom top:(GLfloat)aTop near:(GLfloat)aNear far:(GLfloat)aFar
{
    PBMatrix sOrthoMatrix = PBMatrixIdentity;

    float sDeltaX = aRight - aLeft;
    float sDeltaY = aTop   - aBottom;
    float sDeltaZ = aFar   - aNear;

    if ((sDeltaX == 0.0f) || (sDeltaY == 0.0f) || (sDeltaZ == 0.0f))
    {
        return PBMatrixIdentity;
    }

    sOrthoMatrix.m[0][0] =  2.0f / sDeltaX;
    sOrthoMatrix.m[1][1] =  2.0f / sDeltaY;
    sOrthoMatrix.m[2][2] = -2.0f / sDeltaZ;
    sOrthoMatrix.m[3][0] = -(aRight + aLeft) / sDeltaX;
    sOrthoMatrix.m[3][1] = -(aTop + aBottom) / sDeltaY;
    sOrthoMatrix.m[3][2] = -(aNear + aFar) / sDeltaZ;

    return PBMultiplyMatrix(sOrthoMatrix, aSrc);
}


+ (PBMatrix)translateMatrix:(PBMatrix)aSrc translate:(PBVertex3)aTranslate
{
    aSrc.m[3][0] += (aSrc.m[0][0] * aTranslate.x + aSrc.m[1][0] * aTranslate.y + aSrc.m[2][0] * aTranslate.z);
    aSrc.m[3][1] += (aSrc.m[0][1] * aTranslate.x + aSrc.m[1][1] * aTranslate.y + aSrc.m[2][1] * aTranslate.z);
    aSrc.m[3][2] += (aSrc.m[0][2] * aTranslate.x + aSrc.m[1][2] * aTranslate.y + aSrc.m[2][2] * aTranslate.z);
    aSrc.m[3][3] += (aSrc.m[0][3] * aTranslate.x + aSrc.m[1][3] * aTranslate.y + aSrc.m[2][3] * aTranslate.z);

    return aSrc;
}


+ (PBMatrix)rotateMatrix:(PBMatrix)aSrc angle:(PBVertex3)aAngle
{
    PBMatrix sRotateMatrix = PBMatrixIdentity;
    PBMatrix sMatrix;
    CGFloat  sRadian       = 0.0f;
    CGFloat  sSin          = 0.0f;
    CGFloat  sCos          = 0.0f;
    BOOL     sDirty        = NO;

    if (aAngle.x != 0.0)
    {
        sRotateMatrix = PBMatrixIdentity;
        sRadian = PBDegreesToRadians(aAngle.x);
        sSin = sinf(sRadian);
        sCos = cosf(sRadian);

        sRotateMatrix.m[1][1] = sCos;
        sRotateMatrix.m[1][2] = -sSin;
        sRotateMatrix.m[2][1] = sSin;
        sRotateMatrix.m[2][2] = sCos;

        sMatrix = PBMultiplyMatrix(sRotateMatrix, aSrc);
        aSrc    = sMatrix;
        sDirty  = YES;
    }

    if (aAngle.y != 0.0)
    {
        sRotateMatrix = PBMatrixIdentity;
        sRadian = PBDegreesToRadians(aAngle.y);
        sSin = sinf(sRadian);
        sCos = cosf(sRadian);

        sRotateMatrix.m[0][0] = sCos;
        sRotateMatrix.m[0][2] = sSin;
        sRotateMatrix.m[2][0] = -sSin;
        sRotateMatrix.m[2][2] = sCos;

        sMatrix = PBMultiplyMatrix(sRotateMatrix, aSrc);
        aSrc    = sMatrix;
        sDirty  = YES;
    }

    if (aAngle.z != 0.0)
    {
        sRotateMatrix = PBMatrixIdentity;
        sRadian = PBDegreesToRadians(aAngle.z);
        sSin = sinf(sRadian);
        sCos = cosf(sRadian);

        sRotateMatrix.m[0][0] = sCos;
        sRotateMatrix.m[0][1] = -sSin;
        sRotateMatrix.m[1][0] = sSin;
        sRotateMatrix.m[1][1] = sCos;

        sMatrix = PBMultiplyMatrix(sRotateMatrix, aSrc);
        aSrc    = sMatrix;
        sDirty  = YES;
    }

    if (!sDirty)
    {
        sMatrix = PBMultiplyMatrix(sRotateMatrix, aSrc);
    }

    return sMatrix;
}


+ (PBMatrix)scaleMatrix:(PBMatrix)aSrc scale:(GLfloat)aScale
{
    PBMatrix sScaleMatrix = PBMatrixIdentity;

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

    return PBMultiplyMatrix(sScaleMatrix, aSrc);
}


+ (PBMatrix)frustumMatrix:(PBMatrix)aSrc left:(GLfloat)aLeft right:(GLfloat)aRight bottom:(GLfloat)aBottom top:(GLfloat)aTop nearZ:(GLfloat)aNearZ farZ:(GLfloat)aFarZ
{
    PBMatrix sFrustMatrix = PBMatrixIdentity;

    CGFloat sDeltaX = aRight - aLeft;
    CGFloat sDeltaY = aTop   - aBottom;
    CGFloat sDeltaZ = aFarZ  - aNearZ;

    if ((aNearZ <= 0.0f) || (aFarZ <= 0.0f) || (sDeltaX <= 0.0f) || (sDeltaY <= 0.0f) || (sDeltaZ <= 0.0f))
    {
        return PBMatrixIdentity;
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

    return PBMultiplyMatrix(sFrustMatrix, aSrc);
}


@end
