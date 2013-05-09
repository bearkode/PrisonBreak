/*
 *  PBCamera.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 6..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBCamera.h"


static const GLfloat kOrthogonalNear = 1000;
static const GLfloat kOrthogonalFar  = -1000;


@implementation PBCamera
{
    CGPoint  mPosition;
    CGFloat  mZoomScale;
    CGSize   mViewSize;
    PBMatrix mProjection;
    
    CGFloat  mLeft;
    CGFloat  mRight;
    CGFloat  mBottom;
    CGFloat  mTop;
    
    BOOL     mDidProjectionChange;
}


@synthesize zoomScale  = mZoomScale;
@synthesize position   = mPosition;
@synthesize viewSize   = mViewSize;
@synthesize projection = mProjection;


+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)aKey
{
    BOOL sAutomatic = NO;
    
    if ([aKey isEqualToString:@"position"] || [aKey isEqualToString:@"zoomScale"] || [aKey isEqualToString:@"viewSize"])
    {
        sAutomatic = NO;
    }
    else
    {
        sAutomatic = [super automaticallyNotifiesObserversForKey:aKey];
    }
    
    return sAutomatic;
}


#pragma mark -


- (void)applyProjection
{
    mProjection = [PBMatrixOperator orthoMatrix:PBMatrixIdentity left:mLeft right:mRight bottom:mBottom top:mTop near:kOrthogonalNear far:kOrthogonalFar];
    mDidProjectionChange = YES;
}


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mPosition            = CGPointMake(0, 0);
        mZoomScale           = 1.0;
        mViewSize            = CGSizeZero;
        mDidProjectionChange = YES;
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)setZoomScale:(CGFloat)aZoomScale
{
    if (mZoomScale != aZoomScale)
    {
        [self willChangeValueForKey:@"zoomScale"];
        
        mZoomScale = aZoomScale;
        
        [self didChangeValueForKey:@"zoomScale"];

        [self resetCoordinates];
    }
}


- (void)setPosition:(CGPoint)aPosition
{
    if (!CGPointEqualToPoint(aPosition, mPosition))
    {
        [self willChangeValueForKey:@"position"];
        
        mPosition = aPosition;
        
        [self didChangeValueForKey:@"position"];
        
        [self resetCoordinates];
    }
}


- (void)setViewSize:(CGSize)aViewSize
{
    if (!CGSizeEqualToSize(mViewSize, aViewSize))
    {
        [self willChangeValueForKey:@"viewSize"];
        
        mViewSize = aViewSize;
        
        [self didChangeValueForKey:@"viewSize"];
        
        [self resetCoordinates];
    }
}


- (BOOL)didProjectionChange
{
    if (mDidProjectionChange)
    {
        mDidProjectionChange = NO;
        
        return YES;
    }
    else
    {
        return NO;
    }
}


#pragma mark -


- (void)resetCoordinates
{
    mLeft   = mPosition.x - (mViewSize.width  / 2.0 / mZoomScale);
    mRight  = mPosition.x + (mViewSize.width  / 2.0 / mZoomScale);
    mBottom = mPosition.y - (mViewSize.height / 2.0 / mZoomScale);
    mTop    = mPosition.y + (mViewSize.height / 2.0 / mZoomScale);
    
    [self applyProjection];
}


#pragma mark -


- (CGPoint)convertPointToCanvas:(CGPoint)aPoint
{
    aPoint.x = aPoint.x / mViewSize.width * (mRight - mLeft) + mLeft;
    aPoint.y = (1.0 - aPoint.y / mViewSize.height) * (mTop - mBottom) + mBottom;
    
    return aPoint;
}


- (CGPoint)convertPointToView:(CGPoint)aPoint
{
    aPoint.x = (aPoint.x - mLeft) / (mRight - mLeft) * mViewSize.width;
    aPoint.y = (1.0 - (aPoint.y - mBottom) / (mTop - mBottom)) * mViewSize.height;
    
    return aPoint;
}


@end
