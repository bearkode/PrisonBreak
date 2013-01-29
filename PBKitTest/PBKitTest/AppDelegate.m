/*
 *  AppDelegate.m
 *  PBKitTest
 *
 *  Created by sshanks on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#import "AppDelegate.h"
#import "SampleTestViewController.h"
#import <PBKit.h>


@implementation AppDelegate
{
    UIWindow *mWindow;
}


@synthesize window = mWindow;


#pragma mark -


- (void)dealloc
{
    [mWindow release];
    [super dealloc];
}


#pragma mark -


- (BOOL)application:(UIApplication *)aApplication didFinishLaunchingWithOptions:(NSDictionary *)aLaunchOptions
{
    UIWindow *sWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    [self setWindow:sWindow];
    [sWindow setBackgroundColor:[UIColor whiteColor]];
    [sWindow makeKeyAndVisible];

    SampleTestViewController *sTestViewController = [[[SampleTestViewController alloc] init] autorelease];
    UINavigationController   *sNaviController     = [[[UINavigationController alloc] initWithRootViewController:sTestViewController] autorelease];
    
    [sWindow setRootViewController:sNaviController];
    
    [PBSoundManager sharedManager];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)aApplication
{

}


- (void)applicationDidEnterBackground:(UIApplication *)aApplication
{

}


- (void)applicationWillEnterForeground:(UIApplication *)aApplication
{

}


- (void)applicationDidBecomeActive:(UIApplication *)aApplication
{

}


- (void)applicationWillTerminate:(UIApplication *)aApplication
{

}


@end
