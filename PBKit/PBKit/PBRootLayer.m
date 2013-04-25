/*
 *  PBRootLayer.m
 *  PBKit
 *
 *  Created by camelkode on 13. 4. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBRootLayer.h"
#import "PBCanvas.h"


@implementation PBRootLayer
{
    PBCanvas *mCanvas;
}


- (void)setCanvas:(PBCanvas *)aCanvas
{
// using weak reference
    mCanvas = aCanvas;
}


- (PBCanvas *)canvas
{
    return mCanvas;
}


@end
