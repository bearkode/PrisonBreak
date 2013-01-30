/*
 *  PBTransform.h
 *  PBKit
 *
 *  Created by sshanks on 13. 1. 28..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>


struct
{
    float m[4][4];
} typedef PBMatrix4;


typedef struct {
    CGFloat x1;
    CGFloat x2;
    CGFloat y1;
    CGFloat y2;
} PBMatrix;


static const PBMatrix4 PBMatrix4Identity =
{
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
};


@interface PBTransform : NSObject
{
    CGFloat    mAngle;
    CGFloat    mScale;
    PBVertice3 mTranslate;
}


@property (nonatomic, assign) CGFloat    angle;
@property (nonatomic, assign) CGFloat    scale;
@property (nonatomic, assign) PBVertice3 translate;


+ (PBMatrix4)multiplyWithMatrixA:(PBMatrix4)aMatrixA matrixB:(PBMatrix4)aMatrixB;
+ (PBMatrix4)multiplyOrthoMatrix:(PBMatrix4)aMatrix left:(GLfloat)aLeft right:(GLfloat)aRight bottom:(GLfloat)aBottom top:(GLfloat)aTop near:(GLfloat)aNear far:(GLfloat)aFar;
+ (PBMatrix4)multiplyTranslateMatrix:(PBMatrix4)aMatrix translate:(PBVertice3)aTranslate;
+ (PBMatrix4)multiplyRotationMatrix:(PBMatrix4)aMatrix angle:(CGFloat)aAngle;
+ (PBMatrix4)multiplyFrustumMatrix:(PBMatrix4)aMatrix left:(CGFloat)aLeft right:(CGFloat)aRight bottom:(CGFloat)aBottom top:(CGFloat)aTop nearZ:(CGFloat)aNearZ farZ:(CGFloat)aFarZ;


- (void)multiplyTransform:(PBTransform *)aTransform;
- (void)assignTransform:(PBTransform *)aTransform;


@end
