/*
 *  PBCamera.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 6..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBCamera.h"


@implementation PBCamera
{
    CGPoint   mPosition;
    CGFloat   mZoomScale;
    CGSize    mViewSize;
    PBMatrix4 mProjection;
    
    CGFloat   mLeft;
    CGFloat   mRight;
    CGFloat   mBottom;
    CGFloat   mTop;
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
    mProjection = PBMatrix4Identity;
    
    float sNear   = -1000;
    float sFar    = 1000;
    float sDeltaX = mRight - mLeft;
    float sDeltaY = mTop   - mBottom;
    float sDeltaZ = sFar   - sNear;
    
    if ((sDeltaX == 0.0f) || (sDeltaY == 0.0f) || (sDeltaZ == 0.0f))
    {
        mProjection = PBMatrix4Identity;
    }
    
    mProjection.m[0][0] =  2.0f / sDeltaX;
    mProjection.m[1][1] =  2.0f / sDeltaY;
    mProjection.m[2][2] = -2.0f / sDeltaZ;
    mProjection.m[3][0] = -(mRight + mLeft) / sDeltaX;
    mProjection.m[3][1] = -(mTop + mBottom) / sDeltaY;
    mProjection.m[3][2] = -(sNear + sFar) / sDeltaZ;
}


#pragma mark -


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mPosition  = CGPointMake(0, 0);
        mZoomScale = 1.0;
        mViewSize  = CGSizeZero;
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
    }
}


- (void)setPosition:(CGPoint)aPosition
{
    if (!CGPointEqualToPoint(aPosition, mPosition))
    {
        [self willChangeValueForKey:@"position"];
        
        mPosition = aPosition;
        
        [self didChangeValueForKey:@"position"];
    }
}


- (void)setViewSize:(CGSize)aViewSize
{
    if (!CGSizeEqualToSize(mViewSize, aViewSize))
    {
        [self willChangeValueForKey:@"viewSize"];
        
        mViewSize = aViewSize;
        
        [self didChangeValueForKey:@"viewSize"];
    }
}


#pragma mark -


- (void)generateCoordinates
{
#if (1)
    mLeft   = -(mViewSize.width / 2);
    mRight  = (mViewSize.width / 2);
    mBottom = -(mViewSize.height / 2);
    mTop    = (mViewSize.height / 2);
#else
    mLeft   = 0;
    mRight  = mViewSize.width;
    mBottom = 0;
    mTop    = mViewSize.height;
#endif
    
    [self applyProjection];
}


- (void)resetCoordinatesWithLeft:(CGFloat)aLeft right:(CGFloat)aRight bottom:(CGFloat)aBottom top:(CGFloat)aTop
{
    mLeft   = aLeft;
    mRight  = aRight;
    mBottom = aBottom;
    mTop    = aTop;
    
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
