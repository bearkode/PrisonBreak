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


@end
