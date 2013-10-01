/*
 *  SkeletonSkinItem.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 9. 3..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SkeletonSkinItem.h"
#import "SkeletonDefine.h"


@implementation SkeletonSkinItem
{
    NSString    *mName;
    CGSize       mSize;
    CGFloat      mAngle;
    CGPoint      mOffset;
    CGPoint      mScale;
}


@synthesize name   = mName;
@synthesize size   = mSize;
@synthesize angle  = mAngle;
@synthesize offset = mOffset;
@synthesize scale  = mScale;


- (id)initWithAttachmentName:(NSString *)aAttachmentName attributeData:(NSDictionary *)aAttributeData
{
    self = [super init];
    if (self)
    {
        mName   = [aAttachmentName retain];
        mSize   = CGSizeMake([[aAttributeData objectForKey:kSkeletonWidth] floatValue], [[aAttributeData objectForKey:kSkeletonHeight] floatValue]);
        mAngle  = [[aAttributeData objectForKey:kSkeletonRotation] floatValue];
        mOffset = CGPointMake([[aAttributeData objectForKey:kSkeletonX] floatValue], [[aAttributeData objectForKey:kSkeletonY] floatValue]);
        mScale  = CGPointMake(1.0f, 1.0f);
        if ([aAttributeData objectForKey:kSkeletonScaleX])
        {
            mScale.x = [[aAttributeData objectForKey:kSkeletonScaleX] floatValue];
        }
        if ([aAttributeData objectForKey:kSkeletonScaleY])
        {
            mScale.y = [[aAttributeData objectForKey:kSkeletonScaleY] floatValue];
        }
    }
    
    return self;
}


- (void)dealloc
{
    [mName release];
    
    [super dealloc];
}


@end
