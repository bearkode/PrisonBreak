/*
 *  PBAtlasNode.m
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 29..
 *  Copyright (c) 2013 NHN. All rights reserved.
 *
 */

#import "PBAtlasNode.h"
#import "PBAtlas.h"
#import "PBAtlasItem.h"
#import "PBMutableMesh.h"
#import "PBNodePrivate.h"


@implementation PBAtlasNode
{
    PBAtlas *mAtlas;
    id       mKey;
}


+ (Class)meshClass
{
    return [PBMutableMesh class];
}


#pragma mark -


- (id)initWithAtlas:(PBAtlas *)aAtlas key:(id <NSCopying>)aKey
{
    self = [super initWithTexture:[aAtlas texture]];
    
    if (self)
    {
        mAtlas = [aAtlas retain];

        [self setKey:aKey];
    }
    
    return self;
}


- (void)dealloc
{
    [mAtlas release];
    [mKey release];
    
    [super dealloc];
}


- (void)setKey:(id <NSCopying>)aKey
{
    if (![mKey isEqual:aKey])
    {
        [mKey autorelease];
        mKey = [(id)aKey copy];
        
        PBAtlasItem *sItem = [mAtlas itemForKey:mKey];
        if (sItem)
        {
            [(PBMutableMesh *)[self mesh] setCoordinateRect:[sItem coordRect]];
        }
    }
}


@end
