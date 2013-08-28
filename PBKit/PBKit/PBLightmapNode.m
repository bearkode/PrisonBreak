/*
 *  PBLightmapNode.m
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 28..
 *  Copyright (c) 2013 NHN. All rights reserved.
 *
 */

#import "PBLightmapNode.h"


@implementation PBLightmapNode
{
    PBLightmapNode  *mLeftNode;
    PBLightmapNode  *mRightNode;
    CGRect           mRect;
    UIImage         *mImage;
}


@synthesize rect = mRect;


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}


- (void)dealloc
{
    [mLeftNode release];
    [mRightNode release];
    [mImage release];
    
    [super dealloc];
}


#pragma mark -


- (BOOL)isLeaf
{
    return (mLeftNode && mRightNode) ? NO : YES;
}


- (BOOL)isSmallThen:(CGSize)aSize
{
    if (mRect.size.width < aSize.width || mRect.size.height < aSize.height)
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
    if (mRect.size.width == aSize.width && mRect.size.height == aSize.height)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (PBLightmapNode *)insertImage:(UIImage *)aImage
{
    CGSize sImageSize = [aImage size];
    
    if ([self isLeaf])
    {
        if (mImage || [self isSmallThen:sImageSize])
        {
            return nil;
        }
        
        if ([self isFitTo:sImageSize])
        {
            mImage = [aImage retain];
            return self;
        }
        else
        {
            mLeftNode  = [[PBLightmapNode alloc] init];
            mRightNode = [[PBLightmapNode alloc] init];
            
            CGFloat sWidth  = mRect.size.width  - [aImage size].width;
            CGFloat sHeight = mRect.size.height - [aImage size].height;
            CGRect  sLeftRect;
            CGRect  sRightRect;
            
            if (sWidth > sHeight)
            {
                sLeftRect  = CGRectMake(mRect.origin.x, mRect.origin.y, sImageSize.width, mRect.size.height);
                sRightRect = CGRectMake(mRect.origin.x + sImageSize.width, mRect.origin.y, sWidth, mRect.size.height);
            }
            else
            {
                sLeftRect  = CGRectMake(mRect.origin.x, mRect.origin.y, mRect.size.width, sImageSize.height);
                sRightRect = CGRectMake(mRect.origin.x, mRect.origin.y + sImageSize.height, mRect.size.width, sHeight);
            }
            
            [mLeftNode setRect:sLeftRect];
            [mRightNode setRect:sRightRect];
            
            return [mLeftNode insertImage:aImage];
        }
    }
    else
    {
        PBLightmapNode *sNewNode = [mLeftNode insertImage:aImage];
        
        if (sNewNode)
        {
            return sNewNode;
        }
        else
        {
            return [mRightNode insertImage:aImage];
        }
    }
}


- (UIImage *)atlasImage
{
    UIImage *sResult = nil;

    UIGraphicsBeginImageContextWithOptions(mRect.size, NO, 0);
    {
        CGContextRef sContext = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(sContext, [[UIColor blackColor] CGColor]);
        CGContextFillRect(sContext, mRect);
        
        [self draw];
        
        sResult = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();

    return sResult;
}


- (void)draw
{
    if (mImage)
    {
//        [mImage drawInRect:mRect fromRect:CGRectMake(0, 0, [mImage size].width, [mImage size].height) operation:CompositeSourceAtop fraction:1.0];
        [mImage drawInRect:mRect blendMode:kCGBlendModeSourceAtop alpha:1.0];
    }
    
    CGContextRef sContext = UIGraphicsGetCurrentContext();
    
    if (mImage)
    {
        CGContextSetStrokeColorWithColor(sContext, [[UIColor whiteColor] CGColor]);
    }
    else
    {
        CGContextSetStrokeColorWithColor(sContext, [[UIColor redColor] CGColor]);
    }
    
    CGContextStrokeRect(sContext, mRect);
    
    [mLeftNode draw];
    [mRightNode draw];
}


@end
