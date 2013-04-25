/*
 *  PBRootLayer.h
 *  PBKit
 *
 *  Created by camelkode on 13. 4. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBLayer.h"


@class PBCanvas;


@interface PBRootLayer : PBLayer


- (void)setCanvas:(PBCanvas *)aCanvas;
- (PBCanvas *)canvas;



@end
