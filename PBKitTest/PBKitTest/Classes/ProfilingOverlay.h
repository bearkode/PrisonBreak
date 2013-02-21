/*
 *  ProfilingOverlay.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 2. 21..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>


@interface ProfilingOverlay : NSObject
{
    dispatch_source_t mTimer;
}

+ (ProfilingOverlay *)sharedManager;
+ (void)setHidden:(BOOL)aHidden;
+ (BOOL)isHidden;
+ (BOOL)isTop;
+ (void)setTop:(BOOL)aTop;
+ (void)setAlpha:(float)aAlpha;

+ (void)setFPS:(NSInteger)aFPS;
+ (void)setTimeInterval:(CFTimeInterval)aTimeInterval;

- (void)startCPUMemoryUsages;
- (void)stopCPUMemoryUsages;
- (void)startDisplayFPS;
- (void)stopDisplayFPS;
- (void)displayFPS:(NSInteger)aFPS timeInterval:(CFTimeInterval)aTimeInterval;

@end
