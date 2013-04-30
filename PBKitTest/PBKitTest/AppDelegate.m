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
#import "ProfilingOverlay.h"


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


- (void)showProfilingOverlay
{
    [ProfilingOverlay setHidden:NO];
    [[ProfilingOverlay sharedManager] startCPUMemoryUsages];
}


- (BOOL)application:(UIApplication *)aApplication didFinishLaunchingWithOptions:(NSDictionary *)aLaunchOptions
{
    UIWindow *sWindow = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self setWindow:sWindow];
    [sWindow makeKeyAndVisible];
    
    SampleTestViewController *sTestViewController = [[[SampleTestViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    UINavigationController   *sNaviController     = [[[UINavigationController alloc] initWithRootViewController:sTestViewController] autorelease];
    [sWindow setRootViewController:sNaviController];

    PBSoundManager *sSoundManager = [PBSoundManager sharedManager];
    [sSoundManager loadSoundNamed:kSoundAnimals012 forKey:kSoundAnimals012];
    [sSoundManager loadSoundNamed:kSoundBombExplosion forKey:kSoundBombExplosion];
    [sSoundManager loadSoundNamed:kSoundVulcan forKey:kSoundVulcan];
    
    [self performSelector:@selector(showProfilingOverlay) withObject:nil afterDelay:0.5];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)aApplication
{

}


- (void)applicationDidEnterBackground:(UIApplication *)aApplication
{
//    NSLog(@"didEnterBackground");
    [PBContext performBlock:^{
        glFinish();
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)aApplication
{
//    NSLog(@"willEnterForeground");
}


- (void)applicationDidBecomeActive:(UIApplication *)aApplication
{

}


- (void)applicationWillTerminate:(UIApplication *)aApplication
{

}


@end
