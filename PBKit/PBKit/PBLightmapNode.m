/*
 *  PBLightmapNode.m
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 28..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBLightmapNode.h"
#import "PBAtlasItem.h"


@implementation PBLightmapNode
{
    PBLightmapNode  *mLeftNode;
    PBLightmapNode  *mRightNode;

    CGFloat          mAtlasSize;
    CGRect           mFrame;
    PBAtlasItem     *mItem;
}


@synthesize frame = mFrame;


#pragma mark -


+ (id)rootNodeWithAtlasSize:(CGFloat)aAtlasSize
{
    return [[[PBLightmapNode alloc] initWithAtlasSize:aAtlasSize frame:CGRectMake(0, 0, aAtlasSize, aAtlasSize)] autorelease];
}


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}


- (id)initWithAtlasSize:(CGFloat)aAtlasSize frame:(CGRect)aFrame
{
    self = [super init];
    
    if (self)
    {
        mAtlasSize = aAtlasSize;
        mFrame     = aFrame;
    }
    
    return self;
}


- (void)dealloc
{
    [mLeftNode release];
    [mRightNode release];
    
    [mItem release];
    
    [super dealloc];
}


#pragma mark -


- (BOOL)isLeaf
{
    return (mLeftNode && mRightNode) ? NO : YES;
}


- (BOOL)isSmallThen:(CGSize)aSize
{
    if (mFrame.size.width < aSize.width || mFrame.size.height < aSize.height)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (BOOL)isFitTo:(CGSize)aSize
{
    if (mFrame.size.width == aSize.width && mFrame.size.height == aSize.height)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (PBLightmapNode *)insertItem:(PBAtlasItem *)aItem
{
    CGSize sImageSize = [[aItem image] size];
    
    if ([self isLeaf])
    {
        if (mItem || [self isSmallThen:sImageSize])
        {
            return nil;
        }
        
        if ([self isFitTo:sImageSize])
        {
            mItem = [aItem retain];
            
            [mItem setAtlasSize:mAtlasSize];
            [mItem setCoordRect:mFrame];
            
            return self;
        }
        else
        {
            CGFloat sWidth     = mFrame.size.width  - sImageSize.width;
            CGFloat sHeight    = mFrame.size.height - sImageSize.height;
            CGRect  sLeftRect  = CGRectZero;
            CGRect  sRightRect = CGRectZero;
            
            if (sWidth > sHeight)
            {
                sLeftRect  = CGRectMake(mFrame.origin.x, mFrame.origin.y, sImageSize.width, mFrame.size.height);
                sRightRect = CGRectMake(mFrame.origin.x + sImageSize.width, mFrame.origin.y, sWidth, mFrame.size.height);
            }
            else
            {
                sLeftRect  = CGRectMake(mFrame.origin.x, mFrame.origin.y, mFrame.size.width, sImageSize.height);
                sRightRect = CGRectMake(mFrame.origin.x, mFrame.origin.y + sImageSize.height, mFrame.size.width, sHeight);
            }

            mLeftNode  = [[PBLightmapNode alloc] initWithAtlasSize:mAtlasSize frame:sLeftRect];
            mRightNode = [[PBLightmapNode alloc] initWithAtlasSize:mAtlasSize frame:sRightRect];
            
            return [mLeftNode insertItem:aItem];
        }
    }
    else
    {
        PBLightmapNode *sNewNode = [mLeftNode insertItem:aItem];
        
        return (sNewNode) ? sNewNode : [mRightNode insertItem:aItem];
    }
}


- (UIImage *)atlasImage
{
    UIImage *sResult = nil;

    UIGraphicsBeginImageContextWithOptions(mFrame.size, NO, 0);
    {
        CGContextRef sContext = UIGraphicsGetCurrentContext();
        
#if (0)
        CGContextSetFillColorWithColor(sContext, [[UIColor blackColor] CGColor]);
        CGContextFillRect(sContext, mFrame);
#endif
        
        [self drawInContext:sContext];
        
        sResult = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();

    return sResult;
}


- (void)drawInContext:(CGContextRef)aContext
{
    UIImage *sImage = [mItem image];
    
    [sImage drawInRect:mFrame blendMode:kCGBlendModeCopy alpha:1.0];

#if (0)
    CGColorRef sColor = (sImage) ? [[UIColor whiteColor] CGColor] : [[UIColor redColor] CGColor];

    CGContextSetStrokeColorWithColor(aContext, sColor);
    CGContextStrokeRect(aContext, mFrame);
#endif
    
    [mLeftNode drawInContext:aContext];
    [mRightNode drawInContext:aContext];
}


@end
