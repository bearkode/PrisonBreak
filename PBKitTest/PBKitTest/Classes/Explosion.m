/*
 *  Explosion.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 2. 13..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "Explosion.h"


@implementation Explosion


- (id)init
{
    self = [super initWithImageName:@"exp1" tileSize:CGSizeMake(64, 64)];
    
    if (self)
    {

    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


- (BOOL)update
{
    return ![self selectNextSprite];
}


@end
