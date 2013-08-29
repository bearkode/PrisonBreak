/*
 *  PBAtlas.m
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 28..
 *  Copyright (c) 2013 NHN. All rights reserved.
 *
 */

#import "PBAtlas.h"
#import "PBAtlasItem.h"
#import "PBLightmapNode.h"


#define MAX_ATLAS_SIZE      (2048)
#define ATLAS_SIZE_GROWTH   (32)


@implementation PBAtlas
{
    NSMutableDictionary *mItemDict;
    NSMutableArray      *mItemArray;
    
    PBLightmapNode      *mRootNode;
    UIImage             *mAtlasImage;
}


@synthesize atlasImage = mAtlasImage;


#pragma mark -


+ (id)atlas
{
    return [[[PBAtlas alloc] init] autorelease];
}


#pragma mark -


- (void)sortItems
{
    [mItemArray sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(id aObj1, id aObj2) {
        PBAtlasItem *sItem1 = (PBAtlasItem *)aObj1;
        PBAtlasItem *sItem2 = (PBAtlasItem *)aObj2;
        
        if ([sItem1 dimension] > [sItem2 dimension])
        {
            return NSOrderedAscending;
        }
        else if ([sItem1 dimension] < [sItem2 dimension])
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedSame;
        }
    }];
}


- (PBLightmapNode *)makeRootNode
{
    PBLightmapNode *sRootNode    = nil;
    CGSize          sLargestSize = [[[mItemArray objectAtIndex:0] image] size];
    
    for (CGFloat sAtlasSize = MAX(sLargestSize.width, sLargestSize.height); sAtlasSize <= MAX_ATLAS_SIZE; sAtlasSize += ATLAS_SIZE_GROWTH)
    {
        @autoreleasepool
        {
            BOOL sError = NO;
            
            PBLightmapNode *sNewNode = [PBLightmapNode rootNodeWithAtlasSize:sAtlasSize];
            
            for (PBAtlasItem *sItem in mItemArray)
            {
                if ([sNewNode insertItem:sItem] == nil)
                {
                    sError = YES;
                    break;
                }
            }
            
            if (!sError)
            {
                sRootNode = [sNewNode retain];
                break;
            }
        }
    }

    return [sRootNode autorelease];
}


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mItemDict  = [[NSMutableDictionary alloc] init];
        mItemArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mItemDict release];
    [mItemArray release];

    [mRootNode release];
    [mAtlasImage release];
    
    [super dealloc];
}


#pragma mark -


- (void)addImage:(UIImage *)aImage forKey:(id <NSCopying>)aKey
{
    PBAtlasItem *sItem = [PBAtlasItem atlasItemWithImage:aImage key:aKey];
    
    if ([mItemDict objectForKey:aKey])
    {
        [mItemArray removeObject:[mItemDict objectForKey:aKey]];
    }

    [mItemDict setObject:sItem forKey:aKey];
    [mItemArray addObject:sItem];
}


- (BOOL)generate
{
    [self sortItems];

    [mRootNode autorelease];
    mRootNode = [[self makeRootNode] retain];
    
    [mAtlasImage autorelease];
    mAtlasImage = [[mRootNode atlasImage] retain];
        
    return (mAtlasImage) ? YES : NO;
}


- (CGSize)size
{
    return [mRootNode frame].size;
}


@end
