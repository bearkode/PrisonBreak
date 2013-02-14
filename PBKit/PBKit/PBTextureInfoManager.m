/*
 *  PBTextureInfoManager.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 14..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBTextureInfoManager.h"
#import "PBObjCUtil.h"
#import "PBTextureInfo.h"


@implementation PBTextureInfoManager
{
    NSMutableDictionary *mTextureInfoDict;
}


SYNTHESIZE_SHARED_INSTANCE(PBTextureInfoManager, sharedManager)


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mTextureInfoDict = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    
    return self;
}


- (PBTextureInfo *)textureInfoForKey:(NSString *)aKey
{
    return [mTextureInfoDict objectForKey:aKey];
}


- (void)setTextureInfo:(PBTextureInfo *)aTextureInfo forKey:(NSString *)aKey
{
    NSAssert(aTextureInfo, @"");
    NSAssert(aKey, @"");
    
    [mTextureInfoDict setObject:aTextureInfo forKey:aKey];
}


- (void)_drain
{
    [mTextureInfoDict removeAllObjects];
}


#pragma mark -


+ (void)drain
{
    [[PBTextureInfoManager sharedManager] _drain];
}


+ (PBTextureInfo *)textureInfoWithImageName:(NSString *)aImageName
{
    NSAssert(aImageName, @"");
    
    PBTextureInfoManager *sManager     = [PBTextureInfoManager sharedManager];
    PBTextureInfo        *sTextureInfo = [sManager textureInfoForKey:aImageName];
    
    if (!sTextureInfo)
    {
        sTextureInfo = [[[PBTextureInfo alloc] initWithImageName:aImageName] autorelease];
        [sManager setTextureInfo:sTextureInfo forKey:aImageName];
    }
    
    return sTextureInfo;
}


@end
