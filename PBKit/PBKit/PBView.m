/*
 *  PBView.m
 *  PBKit
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012 PrisonBreak. All rights reserved.
 *
 */


#import "PBKit.h"


@implementation PBView
{
    PBDisplayFrameRate mDisplayFrameRate;
    CADisplayLink     *mDisplayLink;
    CFTimeInterval     mLastTimestamp;
    NSMutableArray    *mSelectableRenderable;
    PBRenderer        *mRenderer;
}


@synthesize displayDelegate = mDisplayDelegate;
@synthesize backgroundColor = mBackgroundColor;
@synthesize renderable      = mRenderable;


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


#pragma mark -


- (void)setup
{
    mDisplayFrameRate     = kPBDisplayFrameRateMid;
 
    [mSelectableRenderable autorelease];
    [mRenderable autorelease];
    [mRenderer autorelease];
    
    mSelectableRenderable = [[NSMutableArray alloc] init];
    mRenderable           = [[PBRenderable alloc] init];
    mRenderer             = [[PBRenderer alloc] init];
}


#pragma mark -


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self)
    {
        CAEAGLLayer *sEAGlLayer = (CAEAGLLayer *)[self layer];
        [sEAGlLayer setOpaque:NO];

        [self setup];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        CAEAGLLayer *sEAGlLayer = (CAEAGLLayer *)[self layer];
        [sEAGlLayer setOpaque:NO];

        [self setup];
    }
    
    return self;
}


- (void)dealloc
{
    [mRenderable release];
    [mRenderer release];
    [mBackgroundColor release];
    [mSelectableRenderable release];
    
    [super dealloc];
}


- (void)layoutSubviews
{
    [mRenderer destroyBuffer];
    [mRenderer createBufferWithLayer:(CAEAGLLayer *)[self layer]];
    [mRenderer generateProjectionMatrix];
}


#pragma mark -


- (void)setDisplayFrameRate:(PBDisplayFrameRate)aFrameRate
{
    mDisplayFrameRate = aFrameRate;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopDisplayLoop];
        [self startDisplayLoop];
    });
}


- (PBDisplayFrameRate)displayFrameRate
{
    return mDisplayFrameRate;
}


- (void)startDisplayLoop
{
    NSAssert([NSThread isMainThread], @"");
    
    if ([self superview] && !mDisplayLink)
    {
        mDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
        [mDisplayLink setFrameInterval:mDisplayFrameRate];
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
    CFTimeInterval sCurrTimestamp;
    CFTimeInterval sTimeInterval;
    
    sCurrTimestamp = [aDisplayLink timestamp];
    sTimeInterval  = (mLastTimestamp == 0) ? 0 : (sCurrTimestamp - mLastTimestamp);
    mLastTimestamp = sCurrTimestamp;
    
    [mRenderer bindingBuffer];
    [mRenderer clearBackgroundColor:mBackgroundColor];

    id sDisplayDelegate = (mDisplayDelegate) ? mDisplayDelegate : self;
    if ([sDisplayDelegate respondsToSelector:@selector(pbViewUpdate:timeInterval:displayLink:)])
    {
        [sDisplayDelegate pbViewUpdate:self timeInterval:sTimeInterval displayLink:mDisplayLink];
    }

    [mRenderer display:mRenderable];
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
