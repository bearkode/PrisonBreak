/*
 *  PBTransform.h
 *  PBKit
 *
 *  Created by sshanks on 13. 1. 28..
 *  Copyright (c) 2013년 NHN. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>


struct
{
    float m[16];
} typedef PBMatrix4;


@interface PBTransform : NSObject
{
    PBMatrix4 mMatrix;
}


@property (nonatomic, assign) PBMatrix4 matrix;


- (void)setAngle:(CGFloat)aAngle;


@end
