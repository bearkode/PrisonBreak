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

#if defined(__ARM_NEON__)
#include <arm_neon.h>
#endif


struct
{
    float m[16];
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
    aSrc.m[12] += (aSrc.m[0] * aTranslate.x + aSrc.m[4] * aTranslate.y + aSrc.m[8] * aTranslate.z);
    aSrc.m[13] += (aSrc.m[1] * aTranslate.x + aSrc.m[5] * aTranslate.y + aSrc.m[9] * aTranslate.z);
    aSrc.m[14] += (aSrc.m[2] * aTranslate.x + aSrc.m[6] * aTranslate.y + aSrc.m[10] * aTranslate.z);
    aSrc.m[15] += (aSrc.m[3] * aTranslate.x + aSrc.m[7] * aTranslate.y + aSrc.m[11] * aTranslate.z);

    return aSrc;
}


static inline PBMatrix PBMultiplyMatrix(PBMatrix aSrcA, PBMatrix aSrcB)
{
    PBMatrix sMatrix;
    
#if defined(__ARM_NEON__)
    float32x4x4_t sMatrixSrcA = *(float32x4x4_t *)&aSrcA;
    float32x4x4_t sMatrixSrcB = *(float32x4x4_t *)&aSrcB;
    float32x4x4_t sMatrixDst;

    sMatrixDst.val[0] = vmulq_n_f32(sMatrixSrcB.val[0], vgetq_lane_f32(sMatrixSrcA.val[0], 0));
    sMatrixDst.val[1] = vmulq_n_f32(sMatrixSrcB.val[0], vgetq_lane_f32(sMatrixSrcA.val[1], 0));
    sMatrixDst.val[2] = vmulq_n_f32(sMatrixSrcB.val[0], vgetq_lane_f32(sMatrixSrcA.val[2], 0));
    sMatrixDst.val[3] = vmulq_n_f32(sMatrixSrcB.val[0], vgetq_lane_f32(sMatrixSrcA.val[3], 0));

    sMatrixDst.val[0] = vmlaq_n_f32(sMatrixDst.val[0], sMatrixSrcB.val[1], vgetq_lane_f32(sMatrixSrcA.val[0], 1));
    sMatrixDst.val[1] = vmlaq_n_f32(sMatrixDst.val[1], sMatrixSrcB.val[1], vgetq_lane_f32(sMatrixSrcA.val[1], 1));
    sMatrixDst.val[2] = vmlaq_n_f32(sMatrixDst.val[2], sMatrixSrcB.val[1], vgetq_lane_f32(sMatrixSrcA.val[2], 1));
    sMatrixDst.val[3] = vmlaq_n_f32(sMatrixDst.val[3], sMatrixSrcB.val[1], vgetq_lane_f32(sMatrixSrcA.val[3], 1));
    
    sMatrixDst.val[0] = vmlaq_n_f32(sMatrixDst.val[0], sMatrixSrcB.val[2], vgetq_lane_f32(sMatrixSrcA.val[0], 2));
    sMatrixDst.val[1] = vmlaq_n_f32(sMatrixDst.val[1], sMatrixSrcB.val[2], vgetq_lane_f32(sMatrixSrcA.val[1], 2));
    sMatrixDst.val[2] = vmlaq_n_f32(sMatrixDst.val[2], sMatrixSrcB.val[2], vgetq_lane_f32(sMatrixSrcA.val[2], 2));
    sMatrixDst.val[3] = vmlaq_n_f32(sMatrixDst.val[3], sMatrixSrcB.val[2], vgetq_lane_f32(sMatrixSrcA.val[3], 2));
    
    sMatrixDst.val[0] = vmlaq_n_f32(sMatrixDst.val[0], sMatrixSrcB.val[3], vgetq_lane_f32(sMatrixSrcA.val[0], 3));
    sMatrixDst.val[1] = vmlaq_n_f32(sMatrixDst.val[1], sMatrixSrcB.val[3], vgetq_lane_f32(sMatrixSrcA.val[1], 3));
    sMatrixDst.val[2] = vmlaq_n_f32(sMatrixDst.val[2], sMatrixSrcB.val[3], vgetq_lane_f32(sMatrixSrcA.val[2], 3));
    sMatrixDst.val[3] = vmlaq_n_f32(sMatrixDst.val[3], sMatrixSrcB.val[3], vgetq_lane_f32(sMatrixSrcA.val[3], 3));

    sMatrix = *(PBMatrix *)&sMatrixDst.val;
#else
    sMatrix.m[0]  = (aSrcA.m[0] * aSrcB.m[0]) + (aSrcA.m[1] * aSrcB.m[4]) + (aSrcA.m[2] * aSrcB.m[8]) + (aSrcA.m[3] * aSrcB.m[12]);
    sMatrix.m[1]  = (aSrcA.m[0] * aSrcB.m[1]) + (aSrcA.m[1] * aSrcB.m[5]) + (aSrcA.m[2] * aSrcB.m[9]) + (aSrcA.m[3] * aSrcB.m[13]);
    sMatrix.m[2]  = (aSrcA.m[0] * aSrcB.m[2]) + (aSrcA.m[1] * aSrcB.m[6]) + (aSrcA.m[2] * aSrcB.m[10]) + (aSrcA.m[3] * aSrcB.m[14]);
    sMatrix.m[3]  = (aSrcA.m[0] * aSrcB.m[3]) + (aSrcA.m[1] * aSrcB.m[7]) + (aSrcA.m[2] * aSrcB.m[11]) + (aSrcA.m[3] * aSrcB.m[15]);
    
    sMatrix.m[4]  = (aSrcA.m[4] * aSrcB.m[0]) + (aSrcA.m[5] * aSrcB.m[4]) + (aSrcA.m[6] * aSrcB.m[8]) + (aSrcA.m[7] * aSrcB.m[12]);
    sMatrix.m[5]  = (aSrcA.m[4] * aSrcB.m[1]) + (aSrcA.m[5] * aSrcB.m[5]) + (aSrcA.m[6] * aSrcB.m[9]) + (aSrcA.m[7] * aSrcB.m[13]);
    sMatrix.m[6]  = (aSrcA.m[4] * aSrcB.m[2]) + (aSrcA.m[5] * aSrcB.m[6]) + (aSrcA.m[6] * aSrcB.m[10]) + (aSrcA.m[7] * aSrcB.m[14]);
    sMatrix.m[7]  = (aSrcA.m[4] * aSrcB.m[3]) + (aSrcA.m[5] * aSrcB.m[7]) + (aSrcA.m[6] * aSrcB.m[11]) + (aSrcA.m[7] * aSrcB.m[15]);
    
    sMatrix.m[8]  = (aSrcA.m[8] * aSrcB.m[0]) + (aSrcA.m[9] * aSrcB.m[4]) + (aSrcA.m[10] * aSrcB.m[8]) + (aSrcA.m[11] * aSrcB.m[12]);
    sMatrix.m[9]  = (aSrcA.m[8] * aSrcB.m[1]) + (aSrcA.m[9] * aSrcB.m[5]) + (aSrcA.m[10] * aSrcB.m[9]) + (aSrcA.m[11] * aSrcB.m[13]);
    sMatrix.m[10] = (aSrcA.m[8] * aSrcB.m[2]) + (aSrcA.m[9] * aSrcB.m[6]) + (aSrcA.m[10] * aSrcB.m[10]) + (aSrcA.m[11] * aSrcB.m[14]);
    sMatrix.m[11] = (aSrcA.m[8] * aSrcB.m[3]) + (aSrcA.m[9] * aSrcB.m[7]) + (aSrcA.m[10] * aSrcB.m[11]) + (aSrcA.m[11] * aSrcB.m[15]);
    
    sMatrix.m[12] = (aSrcA.m[12] * aSrcB.m[0]) + (aSrcA.m[13] * aSrcB.m[4]) + (aSrcA.m[14] * aSrcB.m[8]) + (aSrcA.m[15] * aSrcB.m[12]);
    sMatrix.m[13] = (aSrcA.m[12] * aSrcB.m[1]) + (aSrcA.m[13] * aSrcB.m[5]) + (aSrcA.m[14] * aSrcB.m[9]) + (aSrcA.m[15] * aSrcB.m[13]);
    sMatrix.m[14] = (aSrcA.m[12] * aSrcB.m[2]) + (aSrcA.m[13] * aSrcB.m[6]) + (aSrcA.m[14] * aSrcB.m[10]) + (aSrcA.m[15] * aSrcB.m[14]);
    sMatrix.m[15] = (aSrcA.m[12] * aSrcB.m[3]) + (aSrcA.m[13] * aSrcB.m[7]) + (aSrcA.m[14] * aSrcB.m[11]) + (aSrcA.m[15] * aSrcB.m[15]);
    
#endif

    return sMatrix;
}


static inline PBMatrix PBScaleMatrix(PBMatrix aSrc, GLfloat aScale)
{
    PBMatrix sMatrix;
    
#if defined(__ARM_NEON__)    
    float32x4x4_t sMatrixSrc = *(float32x4x4_t *)&aSrc;
    float32x4x4_t sMatrixDst;
    
    sMatrixDst.val[0] = vmulq_n_f32(sMatrixSrc.val[0], (float32_t)aScale);
    sMatrixDst.val[1] = vmulq_n_f32(sMatrixSrc.val[1], (float32_t)aScale);
    sMatrixDst.val[2] = vmulq_n_f32(sMatrixSrc.val[2], (float32_t)aScale);
    sMatrixDst.val[3] = sMatrixSrc.val[3];

    sMatrix = *(PBMatrix *)&sMatrixDst.val;
#else
    sMatrix = PBMatrixIdentity;
    
    sMatrix.m[0] *= aScale;
    sMatrix.m[1] *= aScale;
    sMatrix.m[2] *= aScale;
    sMatrix.m[3] *= aScale;
    
    sMatrix.m[4] *= aScale;
    sMatrix.m[5] *= aScale;
    sMatrix.m[6] *= aScale;
    sMatrix.m[7] *= aScale;
    
    sMatrix.m[8] *= aScale;
    sMatrix.m[9] *= aScale;
    sMatrix.m[10] *= aScale;
    sMatrix.m[11] *= aScale;
    
    sMatrix = PBMultiplyMatrix(sMatrix, aSrc);
#endif

    return sMatrix;
}


static inline GLfloat PBAngleFromMatrix(PBMatrix aMatrix)
{
    return PBRadiansToDegrees(atan2f(aMatrix.m[4], aMatrix.m[5]));
}


static inline PBVertex3 PBTranslateFromMatrix(PBMatrix aMatrix)
{
    return PBVertex3Make(aMatrix.m[12], aMatrix.m[13], aMatrix.m[14]);
}


static inline GLfloat PBScaleFromMatrix(PBMatrix aMatrix)
{
    return sqrt(aMatrix.m[0] * aMatrix.m[0] + aMatrix.m[4] * aMatrix.m[4]);
}

