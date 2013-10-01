/*
 *  SkeletonSkinAtlasPool.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 10. 1..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SkeletonSkinAtlasPool.h"
#import <../PBCommon/PBObjCUtil.h>


@implementation SkeletonSkinAtlasPool
{
    NSMutableDictionary *mAtlases;
}


SYNTHESIZE_SINGLETON_CLASS(SkeletonSkinAtlasPool, sharedManager)


- (void)setAtlas:(PBAtlas *)aAtlas forKey:(NSString *)aKey
{
    [mAtlases setObject:aAtlas forKey:aKey];
}


- (PBAtlas *)atlasForKey:(NSString *)aKey
{
    return [mAtlases objectForKey:aKey];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mAtlases = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

@end
