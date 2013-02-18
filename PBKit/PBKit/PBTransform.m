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
