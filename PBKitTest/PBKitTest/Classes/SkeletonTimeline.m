/*
 *  SkeletonTimeline.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 9. 11..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SkeletonTimeline.h"


@implementation SkeletonTimeline
{
    NSMutableDictionary *mRotateTimilines;
    CGFloat              mRotateVariation;
}


@synthesize rotateVariation = mRotateVariation;


#pragma mark -


- (void)reset
{
    [mRotateTimilines removeAllObjects];
}


#pragma mark - Rotate

- (void)setRotateAngle:(CGFloat)aAngle angleVariation:(CGFloat)aAngleVariation forKeyFrame:(NSUInteger)aKeyFrame
{
    NSDictionary *sTimelineVariation = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithFloat:aAngle], @"angle",
                                        [NSNumber numberWithFloat:aAngleVariation], @"angleVariation",
                                        nil];
    
    [mRotateTimilines setObject:sTimelineVariation forKey:[NSNumber numberWithUnsignedInteger:aKeyFrame]];
}


- (NSDictionary *)rotateTimelineForKeyFrame:(NSUInteger)aKeyFrame
{
    return [mRotateTimilines objectForKey:[NSNumber numberWithUnsignedInteger:aKeyFrame]];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mRotateTimilines = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mRotateTimilines release];
    
    [super dealloc];
}


@end
