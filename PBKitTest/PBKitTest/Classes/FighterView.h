/*
 *  FighterView.h
 *  PBKitTest
 *
 *  Created by bearkode on 13. 1. 29..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBCanvas.h"


@interface FighterView : PBCanvas

@property (nonatomic, assign) id delegate;

@end


@protocol FighterControlDelegate <NSObject>

- (void)fighterControlDidLeftYaw:(FighterView *)aView;
- (void)fighterControlDidRightYaw:(FighterView *)aView;
- (void)fighterControlDidBalanced:(FighterView *)aView;

@end