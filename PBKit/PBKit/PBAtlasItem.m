/*
 *  PBAtlasItem.m
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 28..
 *  Copyright (c) 2013 NHN. All rights reserved.
 *
 */

#import "PBAtlasItem.h"
#import "PBVertices.h"


@implementation PBAtlasItem
{
    UIImage *mImage;
    id       mKey;
    CGFloat  mDimension;
    
    CGFloat  mAtlasSize;
    GLfloat  mVertices[kMeshVertexSize];
    GLfloat  mCoordinates[kMeshCoordinateSize];
}


@synthesize image     = mImage;
@synthesize size      = mSize;
@synthesize dimension = mDimension;


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
        mDimension = [mImage size].width * [mImage size].height;
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
    return [NSString stringWithFormat:@"AtalsItem %@ - %@ [%d]", mKey, NSStringFromCGSize([mImage size]), (NSInteger)mDimension];
}


#pragma mark -


- (void)setAtlasSize:(CGFloat)aAtlasSize
{
    mAtlasSize = aAtlasSize;
}


- (void)setFrame:(CGRect)aFrame
{
    mVertices[0]  = -(aFrame.size.width / 2);
    mVertices[1]  = (aFrame.size.height / 2);
    mVertices[2]  = 0;
    mVertices[3]  = -(aFrame.size.width / 2);
    mVertices[4]  = -(aFrame.size.height / 2);
    mVertices[5]  = 0;
    mVertices[6]  = (aFrame.size.width / 2);
    mVertices[7]  = -(aFrame.size.height / 2);
    mVertices[8]  = 0;
    mVertices[9]  = (aFrame.size.width / 2);
    mVertices[10] = (aFrame.size.height / 2);
    mVertices[11] = 0;
    
    CGRect sCoord = CGRectMake(aFrame.origin.x / mAtlasSize,
                               aFrame.origin.y / mAtlasSize,
                               aFrame.size.width / mAtlasSize,
                               aFrame.size.height / mAtlasSize);
    
    mCoordinates[0] = sCoord.origin.x;
    mCoordinates[1] = sCoord.origin.y;
    mCoordinates[2] = mCoordinates[0];
    mCoordinates[3] = mCoordinates[1] + sCoord.size.height;
    mCoordinates[4] = mCoordinates[0] + sCoord.size.width;
    mCoordinates[5] = mCoordinates[1] + sCoord.size.height;
    mCoordinates[6] = mCoordinates[0] + sCoord.size.width;
    mCoordinates[7] = mCoordinates[1];
}


@end
