/*
 *  ProfilingOverlayView.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 2. 21..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import <UIKit/UIKit.h>


@interface ProfilingOverlayView : UIWindow


+ (ProfilingOverlayView *)sharedManager;
- (void)setDisplayMessage:(NSString *)aMessage;


@end
