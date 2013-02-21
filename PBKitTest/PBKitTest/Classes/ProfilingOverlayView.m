/*
 *  ProfilingOverlayView.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 2. 21..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "ProfilingOverlayView.h"
#import <../PBCommon/PBObjCUtil.h>



#define kStatusBarHeight 20


@implementation ProfilingOverlayView
{
    UILabel *mMessageLabel;
}

SYNTHESIZE_SINGLETON_CLASS(ProfilingOverlayView, sharedManager);


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect sBounds              = [[UIScreen mainScreen] bounds];
        CGRect sStatusBarFrame      = CGRectMake(0, 0, sBounds.size.width, kStatusBarHeight);
		sStatusBarFrame.size.height = sStatusBarFrame.size.height == 2 * kStatusBarHeight ? kStatusBarHeight : sStatusBarFrame.size.height;

		if (sStatusBarFrame.size.width > sBounds.size.width)
        {
			sStatusBarFrame.size.width = sBounds.size.width;
        }

        [self setWindowLevel:UIWindowLevelStatusBar + 1.0f];
        [self setFrame:sStatusBarFrame];
        [self setAlpha:0.0f];
		[self setHidden:YES];
        [self setBackgroundColor:[UIColor blackColor]];

		mMessageLabel = [[[UILabel alloc] initWithFrame:sStatusBarFrame] autorelease];
        [mMessageLabel setBackgroundColor:[UIColor clearColor]];
        [mMessageLabel setTextAlignment:UITextAlignmentCenter];
        [mMessageLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [mMessageLabel setUserInteractionEnabled:NO];
        [mMessageLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:mMessageLabel];
    }
    return self;
}


- (void)setDisplayMessage:(NSString *)aMessage
{
    [mMessageLabel setText:aMessage];
}


@end
