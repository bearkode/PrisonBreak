/*
 *  PBAtlasItem.m
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 28..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBAtlasItem.h"
#import "PBVertices.h"


@implementation PBAtlasItem
{
    UIImage   *mImage;
    id         mKey;
    NSUInteger mPixelSize;
    
    CGFloat    mAtlasSize;
    CGRect     mCoordRect;
}


@synthesize image     = mImage;
@synthesize pixelSize = mPixelSize;
@synthesize atlasSize = mAtlasSize;
@synthesize coordRect = mCoordRect;


#pragma mark -


+ (id)atlasItemWithImage:(UIImage *)aImage key:(id <NSCopying>)aKey
{
    return [[[PBAtlasItem alloc] initWithImage:aImage key:aKey] autorelease];
}


#pragma mark -


- (id)initWithImage:(UIImage *)aImage key:(id)aKey
{
    self = [super init];
    
    if (self)
    {
        mImage     = [aImage retain];
        mKey       = [aKey retain];
        mPixelSize = [mImage size].width * [mImage size].height;
    }
    
    return self;
}


- (void)dealloc
{
    [mImage release];
    [mKey release];
    
    [super dealloc];
}


#pragma mark -


- (NSString *)description
{
    return [NSString stringWithFormat:@"AtalsItem %@ - %@ [%ld]", mKey, NSStringFromCGSize([mImage size]), mPixelSize];
}


@end
