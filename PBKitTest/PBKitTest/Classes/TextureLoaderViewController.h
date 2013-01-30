/*
 *  TextureLoaderViewController.h
 *  PBKitTest
 *
 *  Created by bearkode on 13. 1. 30..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class TextureLoadView;


@interface TextureLoaderViewController : UIViewController

@property (nonatomic, assign) IBOutlet TextureLoadView *textureLoadView;
@property (nonatomic, assign) IBOutlet UIProgressView  *progressView;

- (IBAction)startButtonTapped:(id)aSender;

@end
