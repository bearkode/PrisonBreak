/*
 *  PBRootNode.h
 *  PBKit
 *
 *  Created by camelkode on 13. 4. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBNode.h"


@class PBCanvas;


@interface PBRootNode : PBNode


- (void)setCanvas:(PBCanvas *)aCanvas;
- (PBCanvas *)canvas;



@end
