/*
 *  PBMatrix.m
 *  PBKit
 *
 *  Created by camelkode on 13. 2. 26..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import "PBVertices.h"


struct
{
    float m[4][4];
} typedef PBMatrix;


static const PBMatrix PBMatrixIdentity =
{
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
};


#pragma mark - PBMatrixOperator


@interface PBMatrixOperator : NSObject


#pragma mark -


+ (NSString *)description:(PBMatrix)aMatrix;


#pragma mark - 


+ (PBMatrix)multiplyMatrixA:(PBMatrix)aSrcA matrixB:(PBMatrix)aSrcB;
+ (PBMatrix)orthoMatrix:(PBMatrix)aSrc left:(GLfloat)aLeft right:(GLfloat)aRight bottom:(GLfloat)aBottom top:(GLfloat)aTop near:(GLfloat)aNear far:(GLfloat)aFar;
+ (PBMatrix)translateMatrix:(PBMatrix)aSrc translate:(PBVertex3)aTranslate;
+ (PBMatrix)rotateMatrix:(PBMatrix)aSrc angle:(PBVertex3)aAngle;
+ (PBMatrix)scaleMatrix:(PBMatrix)aSrc scale:(GLfloat)aScale;
+ (PBMatrix)frustumMatrix:(PBMatrix)aSrc left:(GLfloat)aLeft right:(GLfloat)aRight bottom:(GLfloat)aBottom top:(GLfloat)aTop nearZ:(GLfloat)aNearZ farZ:(GLfloat)aFarZ;
+ (PBMatrix)perspectiveMatrix:(PBMatrix)aSrc fovy:(GLfloat)aFovy aspect:(GLfloat)aAspect nearZ:(GLfloat)aNearZ farZ:(GLfloat)aFarZ;


@end


PBMatrix PBRotateMatrix(PBMatrix aSrc, PBVertex3 aAngle);


static inline PBMatrix PBTranslateMatrix(PBMatrix aSrc, PBVertex3 aTranslate)
{
    aSrc.m[3][0] += (aSrc.m[0][0] * aTranslate.x + aSrc.m[1][0] * aTranslate.y + aSrc.m[2][0] * aTranslate.z);
    aSrc.m[3][1] += (aSrc.m[0][1] * aTranslate.x + aSrc.m[1][1] * aTranslate.y + aSrc.m[2][1] * aTranslate.z);
    aSrc.m[3][2] += (aSrc.m[0][2] * aTranslate.x + aSrc.m[1][2] * aTranslate.y + aSrc.m[2][2] * aTranslate.z);
    aSrc.m[3][3] += (aSrc.m[0][3] * aTranslate.x + aSrc.m[1][3] * aTranslate.y + aSrc.m[2][3] * aTranslate.z);
    
    return aSrc;
}


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


static inline PBMatrix PBScaleMatrix(PBMatrix aSrc, GLfloat aScale)
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


