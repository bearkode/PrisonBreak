/*
 *  SkeletonSkin.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 9. 3..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SkeletonSkin.h"
#import "SkeletonSkinItem.h"
#import "SkeletonSkinAtlasPool.h"


@implementation SkeletonSkin
{
    NSString            *mName;
    NSMutableDictionary *mSkinItems;
    PBAtlas             *mAtlas;
}


#pragma mark -


- (NSString *)atlasKeyFromFilename:(NSString *)aFilename skinname:(NSString *)aSkinname
{
    return [NSString stringWithFormat:@"%@_%@", aFilename, aSkinname];
}


- (void)generateAtlasWithSkinname:(NSString *)aSkinname filename:(NSString *)aFilename
{
    NSString *sAtlasKey = [self atlasKeyFromFilename:aFilename skinname:aSkinname];
    mAtlas = [[[SkeletonSkinAtlasPool sharedManager] atlasForKey:sAtlasKey] retain];
    if (!mAtlas)
    {
        mAtlas = [[PBAtlas alloc] init];
        [mSkinItems enumerateKeysAndObjectsUsingBlock:^(NSString *aAttachmentName, SkeletonSkinItem *aSkinItem, BOOL *aStop) {
            [mAtlas addImage:[UIImage imageNamed:aAttachmentName] forKey:aAttachmentName];
        }];
        [mAtlas generate];
        
        [[SkeletonSkinAtlasPool sharedManager] setAtlas:mAtlas forKey:sAtlasKey];
    }
}


#pragma mark -


- (PBAtlasNode *)atlasNodeForKey:(NSString *)aKey
{
    return [[[PBAtlasNode alloc] initWithAtlas:mAtlas key:aKey] autorelease];
}


- (SkeletonSkinItem *)skinItemForAttachmentName:(NSString *)aAttachmentName
{
    return [mSkinItems objectForKey:aAttachmentName];
}


#pragma mark -


- (id)initWithSkinname:(NSString *)aSkinname data:(NSDictionary *)aSkinData filename:(NSString *)aFilename
{
    self = [super init];
    if (self)
    {
        mName      = [aSkinname retain];
        mSkinItems = [[NSMutableDictionary alloc] init];
        
        [aSkinData enumerateKeysAndObjectsUsingBlock:^(NSString *aSlotName, NSDictionary *aAttachmentData, BOOL *aStop) {
            [aAttachmentData enumerateKeysAndObjectsUsingBlock:^(NSString *aAttachmentName, NSDictionary *aAttributeData, BOOL *aStop) {
                SkeletonSkinItem *sSkinItem = [[[SkeletonSkinItem alloc] initWithAttachmentName:aAttachmentName attributeData:aAttributeData] autorelease];
                if ([mSkinItems objectForKey:aAttachmentName])
                {
                    NSLog(@"exception");
                }

                [mSkinItems setObject:sSkinItem forKey:aAttachmentName];
            }];
        }];

        [self generateAtlasWithSkinname:aSkinname filename:aFilename];
    }
    
    return self;
}


- (void)dealloc
{
    [mAtlas release];
    [mSkinItems release];
    [mName release];
    
    [super dealloc];
}


@end
