/*
 *  Explosion.h
 *  PBKitTest
 *
 *  Created by bearkode on 13. 2. 13..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <PBKit.h>


@interface Explosion : PBRenderable

- (id)initWithTextureInfo:(PBTextureInfo *)aTextureInfo;
- (BOOL)update;

@end
