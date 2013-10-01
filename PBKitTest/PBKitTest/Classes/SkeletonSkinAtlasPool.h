/*
 *  SkeletonSkinAtlasPool.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 10. 1..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <Foundation/Foundation.h>


@class PBAtlas;


@interface SkeletonSkinAtlasPool : NSObject


#pragma mark -


+ (SkeletonSkinAtlasPool *)sharedManager;


- (void)setAtlas:(PBAtlas *)aAtlas forKey:(NSString *)aKey;
- (PBAtlas *)atlasForKey:(NSString *)aKey;


@end
