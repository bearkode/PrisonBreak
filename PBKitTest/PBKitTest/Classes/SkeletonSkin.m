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


@implementation SkeletonSkin
{
    NSString            *mName;
    NSMutableDictionary *mSkinItems;
    PBAtlas             *mAtlas;
}


#pragma mark -


#pragma mark -


- (void)generateAtlas
{
    [mAtlas autorelease];
    mAtlas = [[PBAtlas alloc] init];
    
    [mSkinItems enumerateKeysAndObjectsUsingBlock:^(NSString *aAttachmentName, SkeletonSkinItem *aSkinItem, BOOL *aStop) {
        [mAtlas addImage:[UIImage imageNamed:aAttachmentName] forKey:aAttachmentName];
    }];
    
    [mAtlas generate];
}


- (PBAtlasNode *)atlasNodeForKey:(NSString *)aKey
{
    return [[[PBAtlasNode alloc] initWithAtlas:mAtlas key:aKey] autorelease];
}


- (SkeletonSkinItem *)skinItemForAttachmentName:(NSString *)aAttachmentName
{
    return [mSkinItems objectForKey:aAttachmentName];
}


#pragma mark -


- (id)initWithSkinName:(NSString *)aSkinName data:(NSDictionary *)aSkinData
{
    self = [super init];
    if (self)
    {
        mName      = [aSkinName retain];
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
        
        [self generateAtlas];
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
