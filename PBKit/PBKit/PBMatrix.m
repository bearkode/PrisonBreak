/*
 *  PBMatrix.m
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 26..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import <QuartzCore/QuartzCore.h>
#import "PBMatrix.h"
#import "PBMacro.h"


PBMatrix PBRotateMatrix(PBMatrix aSrc, PBVertex3 aAngle)
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
        
        sRotateMatrix.m[5]  = sCos;
        sRotateMatrix.m[6]  = -sSin;
        sRotateMatrix.m[9]  = sSin;
        sRotateMatrix.m[10] = sCos;
        
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
        
        sRotateMatrix.m[0] = sCos;
        sRotateMatrix.m[2] = sSin;
        sRotateMatrix.m[8] = -sSin;
        sRotateMatrix.m[10] = sCos;
        
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

        sRotateMatrix.m[0] = sCos;
        sRotateMatrix.m[1] = -sSin;
        sRotateMatrix.m[4] = sSin;
        sRotateMatrix.m[5] = sCos;
        
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


@implementation PBMatrixOperator


+ (NSString *)description:(PBMatrix)aMatrix
{
	NSMutableString* desc = [NSMutableString stringWithCapacity: 200];
	[desc appendFormat: @"\n\t[%.3f, ", aMatrix.m[0]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[4]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[8]];
	[desc appendFormat: @"%.3f,\n\t ", aMatrix.m[12]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[1]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[5]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[9]];
	[desc appendFormat: @"%.3f,\n\t ", aMatrix.m[13]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[2]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[6]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[10]];
	[desc appendFormat: @"%.3f,\n\t ", aMatrix.m[14]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[3]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[7]];
	[desc appendFormat: @"%.3f, ", aMatrix.m[11]];
	[desc appendFormat: @"%.3f]", aMatrix.m[15]];
	return desc;
}


+ (PBMatrix)orthoMatrix:(PBMatrix)aSrc left:(GLfloat)aLeft right:(GLfloat)aRight bottom:(GLfloat)aBottom top:(GLfloat)aTop near:(GLfloat)aNear far:(GLfloat)aFar
{
    PBMatrix sMatrix = PBMatrixIdentity;

    float sDeltaX = aRight - aLeft;
    float sDeltaY = aTop   - aBottom;
    float sDeltaZ = aFar   - aNear;

    if ((sDeltaX == 0.0f) || (sDeltaY == 0.0f) || (sDeltaZ == 0.0f))
    {
        return PBMatrixIdentity;
    }
    sMatrix.m[0] =  2.0f / sDeltaX;
    sMatrix.m[5] =  2.0f / sDeltaY;
    sMatrix.m[10] = -2.0f / sDeltaZ;
    sMatrix.m[12] = -(aRight + aLeft) / sDeltaX;
    sMatrix.m[13] = -(aTop + aBottom) / sDeltaY;
    sMatrix.m[14] = -(aNear + aFar) / sDeltaZ;

    return PBMultiplyMatrix(sMatrix, aSrc);
}


+ (PBMatrix)translateMatrix:(PBMatrix)aSrc translate:(PBVertex3)aTranslate
{
    return PBTranslateMatrix(aSrc, aTranslate);
}


+ (PBMatrix)rotateMatrix:(PBMatrix)aSrc angle:(PBVertex3)aAngle
{
    return PBRotateMatrix(aSrc, aAngle);
}


+ (PBMatrix)scaleMatrix:(PBMatrix)aSrc scale:(PBVertex3)aScale
{
    return PBScaleMatrix(aSrc, aScale);
}


+ (PBMatrix)frustumMatrix:(PBMatrix)aSrc left:(GLfloat)aLeft right:(GLfloat)aRight bottom:(GLfloat)aBottom top:(GLfloat)aTop nearZ:(GLfloat)aNearZ farZ:(GLfloat)aFarZ
{
    PBMatrix sMatrix = PBMatrixIdentity;

    CGFloat sDeltaX = aRight - aLeft;
    CGFloat sDeltaY = aTop   - aBottom;
    CGFloat sDeltaZ = aFarZ  - aNearZ;

    if ((aNearZ <= 0.0f) || (aFarZ <= 0.0f) || (sDeltaX <= 0.0f) || (sDeltaY <= 0.0f) || (sDeltaZ <= 0.0f))
    {
        return PBMatrixIdentity;
    }

    sMatrix.m[0] = 2.0f * aNearZ / sDeltaX;
    sMatrix.m[1] = sMatrix.m[2] = sMatrix.m[3] = 0.0f;
    
    sMatrix.m[5] = 2.0f * aNearZ / sDeltaY;
    sMatrix.m[4] = sMatrix.m[6] = sMatrix.m[7] = 0.0f;
    
    sMatrix.m[8] = (aRight + aLeft)  / sDeltaX;
    sMatrix.m[9] = (aTop + aBottom)  / sDeltaY;
    sMatrix.m[10] = -(aNearZ + aFarZ) / sDeltaZ;
    sMatrix.m[11] = -1.0f;
    
    sMatrix.m[14] = -2.0f * aNearZ * aFarZ / sDeltaZ;
    sMatrix.m[12] = sMatrix.m[13] = sMatrix.m[15] = 0.0f;

    return PBMultiplyMatrix(sMatrix, aSrc);
}


+ (PBMatrix)perspectiveMatrix:(PBMatrix)aSrc fovy:(GLfloat)aFovy aspect:(GLfloat)aAspect nearZ:(GLfloat)aNearZ farZ:(GLfloat)aFarZ
{
    GLfloat frustumW, frustumH;
    
    frustumH = tanf( aFovy / 360.0f * M_PI ) * aNearZ;
    frustumW = frustumH * aAspect;
    
    return [PBMatrixOperator frustumMatrix:aSrc left:-frustumW right:frustumW bottom:-frustumH top:frustumH nearZ:aNearZ farZ:aFarZ];
}


@end
