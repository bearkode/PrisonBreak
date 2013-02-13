/*
 *  PBSprite.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 13..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBRenderable.h"


@interface PBSprite : PBRenderable

- (id)initWithImageName:(NSString *)aImageName;

- (PBVertex3)angle;
- (void)setAngle:(PBVertex3)aAngle;

@end
