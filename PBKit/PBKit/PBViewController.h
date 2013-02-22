/*
 *  PBViewController.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 22..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class PBCanvas;


@interface PBViewController : UIViewController

@property (nonatomic, readonly) PBCanvas *canvas;

@end
