/*
 *  Fighter.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 1. 30..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "Fighter.h"


@implementation Fighter
{
    PBTexture *mBalancedTexture;
    PBTexture *mLeftYawTexture;
    PBTexture *mRightYawTexture;
}


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mBalancedTexture = [[PBTexture alloc] initWithImageName:@"5fc.png"];
        mLeftYawTexture  = [[PBTexture alloc] initWithImageName:@"5fl.png"];
        mRightYawTexture = [[PBTexture alloc] initWithImageName:@"5fr.png"];
        
        [mBalancedTexture loadIfNeeded];
        [mLeftYawTexture loadIfNeeded];
        [mRightYawTexture loadIfNeeded];
        
        [self setTexture:mBalancedTexture];
        [self setScale:PBVertex3Make(0.2f, 0.2f, 1.0f)];
        [self setPoint:CGPointMake(0, 0)];
    }
    
    return self;
}


- (void)dealloc
{
    [mBalancedTexture release];
    [mLeftYawTexture release];
    [mRightYawTexture release];
    
    [super dealloc];
}


#pragma mark -


- (void)yawLeft
{
    [self setTexture:mLeftYawTexture];
}


- (void)yawRight
{
    [self setTexture:mRightYawTexture];
}


- (void)balance
{
    [self setTexture:mBalancedTexture];
}


@end
