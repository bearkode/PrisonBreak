/*
 *  PBSprite.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 13..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBLayer.h"


@class PBTextureInfo;


@interface PBSprite : PBLayer

- (id)initWithImageName:(NSString *)aImageName;
- (id)initWithTextureInfo:(PBTextureInfo *)aTextureInfo;

@end
