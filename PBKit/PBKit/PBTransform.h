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
    PBMatrix4  mMatrix;
    PBVertice3 mTranslate;
}


@property (nonatomic, assign) CGFloat    angle;
@property (nonatomic, assign) PBMatrix4  matrix;
@property (nonatomic, assign) PBVertice3 translate;


- (PBMatrix4)applyTranslate:(PBMatrix4)aMatrix;
- (PBMatrix4)applyRotation:(PBMatrix4)aMatrix;
- (PBMatrix4)applyFrustum:(PBMatrix4)aMatrix left:(CGFloat)aLeft right:(CGFloat)aRight top:(CGFloat)aTop bottom:(CGFloat)aBottom nearZ:(CGFloat)aNearZ farZ:(CGFloat)aFarZ;


- (PBMatrix4)multiplyWithSrcA:(PBMatrix4)aMatrixA srcB:(PBMatrix4)aMatrixB;


@end
