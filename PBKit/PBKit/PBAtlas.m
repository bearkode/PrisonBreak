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
    
    UIImage             *mAtlasImage;
}


@synthesize atlasImage = mAtlasImage;


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


- (PBLightmapNode *)detectAtlasSize
{
    PBLightmapNode *sNode        = nil;
    CGSize          sLargestSize = [[[mItemArray objectAtIndex:0] image] size];
    
    for (CGFloat sAtlasSize = MAX(sLargestSize.width, sLargestSize.height); sAtlasSize <= MAX_ATLAS_SIZE; sAtlasSize += ATLAS_SIZE_GROWTH)
    {
        @autoreleasepool
        {
            BOOL sError = NO;
            
            PBLightmapNode *sNewNode  = [[[PBLightmapNode alloc] init] autorelease];
            [sNewNode setRect:CGRectMake(0, 0, sAtlasSize, sAtlasSize)];
            
            for (PBAtlasItem *sItem in mItemArray)
            {
                if ([sNewNode insertImage:[sItem image]] == nil)
                {
                    sError = YES;
                    break;
                }
            }
            
            if (!sError)
            {
                sNode = [sNewNode retain];
                break;
            }
        }
    }

    NSLog(@"atlas size - %f", [sNode rect].size.width);
    
    return [sNode autorelease];
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
    BOOL sResult = NO;
    
    [self sortItems];
    NSLog(@"mItemArray = %@", mItemArray);
    
    PBLightmapNode *sNode = [self detectAtlasSize];
    
    if (sNode)
    {
        [mAtlasImage autorelease];
        mAtlasImage = [[sNode atlasImage] retain];
        
        if (mAtlasImage)
        {
            sResult = YES;
        }
    }
    
    return sResult;
}


@end
