/*
 *  PBView.m
 *  PBKit
 *
 *  Created by sshanks on 12. 12. 27..
 *  Copyright (c) 2012년 sshanks. All rights reserved.
 *
 */


#import "PBKit.h"


@implementation PBView
{
    CADisplayLink  *mDisplayLink;
    NSMutableArray *mSelectableRenderable;
    PBRenderer     *mRenderer;
}


@synthesize displayDelegate = mDisplayDelegate;
@synthesize backgroundColor = mBackgroundColor;
@synthesize superRenderable = mSuperRenderable;


#pragma mark -


- (void)registGestureEvent
{
    UITapGestureRecognizer *sGestureSingleTap       = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureDetected:)] autorelease];
    [sGestureSingleTap setDelegate:self];
    [sGestureSingleTap setNumberOfTapsRequired:1];
    [self addGestureRecognizer:sGestureSingleTap];
    
    UILongPressGestureRecognizer *sLongPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureDetected:)] autorelease];
    [sLongPressGesture setDelegate:self];
    [self addGestureRecognizer:sLongPressGesture];
}


#pragma mark -


+(Class)layerClass
{
	return [CAEAGLLayer class];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CAEAGLLayer *sEAGlLayer = (CAEAGLLayer *)self.layer;
        [sEAGlLayer setOpaque:NO];
        
        mSelectableRenderable = [[NSMutableArray alloc] init];
        mSuperRenderable      = [[PBRenderable alloc] init];
        mRenderer             = [[PBRenderer alloc] init];
    }
    return self;
}


- (void)dealloc
{
    [mSuperRenderable release];
    [mRenderer release];
    [mBackgroundColor release];
    [mSelectableRenderable release];
    
    [super dealloc];
}


- (void)layoutSubviews
{
    [mRenderer destroyBuffer];
    [mRenderer createBufferWithLayer:(CAEAGLLayer *)self.layer];
}


#pragma mark -


- (void)startDisplayLoop
{
    NSAssert([NSThread isMainThread], @"");
    
    if ([self superview] && !mDisplayLink)
    {
        mDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
        [mDisplayLink setFrameInterval:2];
        [mDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}


- (void)stopDisplayLoop
{
    NSAssert([NSThread isMainThread], @"");
    
    [mDisplayLink invalidate];    
    mDisplayLink = nil;
}


- (void)addSelectableRenderable:(PBRenderable *)aRenderable
{
    [mSelectableRenderable addObject:aRenderable];
}


- (void)removeSelectableRenderable:(PBRenderable *)aRenderable
{
    [mSelectableRenderable removeObject:aRenderable];
}


//- (PBRenderObject *)selectedRenderable:(CGPoint)aPoint
//{
//    for (NSInteger i = 0; i < [mSelectableRenderable count]; i++)
//    {
//        PBRenderObject *sRenderObject = [mSelectableRenderable objectAtIndex:i];
//        CGRect screenCoordinate = [sRenderObject screenCoordinate];
//        
//        if (CGRectContainsPoint(screenCoordinate, aPoint))
//        {
//            return sRenderObject;
//        }
//    }
//
//    return nil;
//}


#pragma mark -


- (void)update:(CADisplayLink *)aDisplayLink
{
    id sDisplayDelegate  = (mDisplayDelegate) ? mDisplayDelegate : self;
    [mRenderer displayRenderable:mSuperRenderable
                 backgroundColor:mBackgroundColor
                        delegate:sDisplayDelegate
                        selector:@selector(rendering)];
}


#pragma mark -



- (void)singleTapGestureDetected:(UIPanGestureRecognizer *)aGesture
{
    if ([aGesture state] == UIGestureRecognizerStateEnded)
    {
        CGPoint sPoint = [aGesture locationInView:[aGesture view]];
        if ([self respondsToSelector:@selector(pbView:didTapPoint:)])
        {
            [(id <PBGestureEventDelegate>)self pbView:self didTapPoint:sPoint];
        }
    }
}

- (void)longPressGestureDetected:(UIPanGestureRecognizer *)aGesture
{
    if ([aGesture state] == UIGestureRecognizerStateBegan)
    {
        CGPoint sPoint = [aGesture locationInView:[aGesture view]];
        if ([self respondsToSelector:@selector(pbView:didLongTapPoint:)])
        {
            [(id <PBGestureEventDelegate>)self pbView:self didLongTapPoint:sPoint];
        }
    }
}


@end
