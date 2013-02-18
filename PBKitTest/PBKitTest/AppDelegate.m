/*
 *  AppDelegate.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#import "AppDelegate.h"
#import "SampleTestViewController.h"
#import <PBKit.h>
#import "SoundKeys.h"


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
    
    PBSoundManager *sSoundManager = [PBSoundManager sharedManager];
    [sSoundManager loadSoundNamed:kSoundAnimals012 forKey:kSoundAnimals012];
    [sSoundManager loadSoundNamed:kSoundBombExplosion forKey:kSoundBombExplosion];
    [sSoundManager loadSoundNamed:kSoundVulcan forKey:kSoundVulcan];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)aApplication
{

}


- (void)applicationDidEnterBackground:(UIApplication *)aApplication
{
    NSLog(@"didEnterBackground");
}


- (void)applicationWillEnterForeground:(UIApplication *)aApplication
{
    NSLog(@"willEnterForeground");
}


- (void)applicationDidBecomeActive:(UIApplication *)aApplication
{

}


- (void)applicationWillTerminate:(UIApplication *)aApplication
{

}


@end
