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
        [PBContext performBlockOnMainThread:^{
            [self setProgram:[[PBProgramManager sharedManager] program]];
        }];
        
        mBalancedTexture = [[PBTexture alloc] initWithImageName:@"5fc.png"];
        mLeftYawTexture  = [[PBTexture alloc] initWithImageName:@"5fl.png"];
        mRightYawTexture = [[PBTexture alloc] initWithImageName:@"5fr.png"];
        
        [mBalancedTexture load];
        [mLeftYawTexture load];
        [mRightYawTexture load];
        
        [self setTexture:mBalancedTexture];
        [[self transform] setScale:0.2];
        [self setPosition:CGPointMake(0, 0)];
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


- (void)setScale:(CGFloat)aScale
{
    [[self transform] setScale:aScale];
}


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
