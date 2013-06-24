/*
 *  PBSprite.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 13..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBNode.h"


@class PBTexture;


@interface PBSprite : PBNode

- (id)initWithImageName:(NSString *)aImageName;
- (id)initWithTexture:(PBTexture *)aTexture;

@end
