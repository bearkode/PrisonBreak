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
    id                 mDelegate;
    PBDisplayFrameRate mDisplayFrameRate;
    CADisplayLink     *mDisplayLink;
    CFTimeInterval     mLastTimestamp;
    
    PBCamera          *mCamera;
    PBRenderer        *mRenderer;
    
    PBRenderable      *mRenderable;
    
    PBColor           *mBackgroundColor;
}


@synthesize delegate        = mDelegate;
@synthesize backgroundColor = mBackgroundColor;
@synthesize renderable      = mRenderable;
@synthesize renderer        = mRenderer;
@synthesize camera          = mCamera;


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
    CAEAGLLayer  *sLayer      = (CAEAGLLayer *)[self layer];
    NSDictionary *sProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
                                                                           kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
    [sLayer setDrawableProperties:sProperties];
    [sLayer setOpaque:[self isOpaque]];
    [sLayer addObserver:self forKeyPath:@"bounds" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];

    mDisplayFrameRate     = kPBDisplayFrameRateMid;
 
    [mRenderable autorelease];
    [mRenderer autorelease];
    
    mRenderable           = [[PBRenderable alloc] init];
    mRenderer             = [[PBRenderer alloc] init];
    mCamera               = [[PBCamera alloc] init];
    [mCamera setViewSize:[self bounds].size];
    [mCamera generateCoordinates];
    
    [mCamera addObserver:self forKeyPath:@"position" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
    [mCamera addObserver:self forKeyPath:@"zoomScale" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
    [mCamera addObserver:self forKeyPath:@"viewSize" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
    
    [mRenderer resetRenderBufferWithLayer:sLayer];
}


#pragma mark -


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self)
    {
        [self setup];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self setup];
    }
    
    return self;
}


- (void)dealloc
{
    [[self layer] removeObserver:self forKeyPath:@"bounds"];
    
    [mCamera removeObserver:self forKeyPath:@"position"];
    [mCamera removeObserver:self forKeyPath:@"zoomScale"];
    [mCamera removeObserver:self forKeyPath:@"viewSize"];
    
    [PBContext performBlock:^{
        [mRenderable release];
        [mRenderer release];
        [mCamera release];
        
        [mBackgroundColor release];
    }];
    
    [super dealloc];
}


- (void)resetCoordinates
{
    CGPoint sPosition   = [mCamera position];
    CGFloat sZoomScale  = [mCamera zoomScale];
    GLfloat sViewWidth  = (GLfloat)[mCamera viewSize].width;
    GLfloat sViewHeight = (GLfloat)[mCamera viewSize].height;
    
    GLfloat sLeft   = -(sViewWidth / 2 / sZoomScale) + sPosition.x;
    GLfloat sRight  = (sViewWidth / 2 / sZoomScale) + sPosition.x;
    GLfloat sBottom = -(sViewHeight / 2 / sZoomScale) + sPosition.y;
    GLfloat sTop    = (sViewHeight / 2 / sZoomScale) + sPosition.y;
    
    [mCamera resetCoordinatesWithLeft:sLeft right:sRight bottom:sBottom top:sTop];
}


- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)aObject change:(NSDictionary *)aChange context:(void *)aContext
{
    if ((aObject == [self layer]) && [aKeyPath isEqualToString:@"bounds"])
    {
        CGSize sOldSize = [[aChange objectForKey:NSKeyValueChangeOldKey] CGRectValue].size;
        CGSize sNewSize = [[aChange objectForKey:NSKeyValueChangeNewKey] CGRectValue].size;
        
        if (!CGSizeEqualToSize(sOldSize, sNewSize))
        {
            [PBContext performBlock:^{
                [mRenderer resetRenderBufferWithLayer:(CAEAGLLayer *)[self layer]];
            }];
        }
    }
    else if (aObject == mCamera)
    {
        if ([aKeyPath isEqualToString:@"position"] || [aKeyPath isEqualToString:@"zoomScale"] || [aKeyPath isEqualToString:@"viewSize"])
        {
            [self resetCoordinates];
        }
    }
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


#pragma mark -


- (void)update:(CADisplayLink *)aDisplayLink
{
    CFTimeInterval sCurrTimestamp;
    CFTimeInterval sTimeInterval;
    
    sCurrTimestamp = [aDisplayLink timestamp];
    sTimeInterval  = (mLastTimestamp == 0) ? 0 : (sCurrTimestamp - mLastTimestamp);
    mLastTimestamp = sCurrTimestamp;
    
    [PBContext performBlock:^{
        [mRenderer bindingBuffer];
        [mRenderer clearBackgroundColor:mBackgroundColor];
        
        id sDelegate = (mDelegate) ? mDelegate : self;
        if ([sDelegate respondsToSelector:@selector(pbViewUpdate:timeInterval:displayLink:)])
        {
            [sDelegate pbViewUpdate:self timeInterval:sTimeInterval displayLink:mDisplayLink];
        }
        
        [mRenderer render:mRenderable projection:[mCamera projection]];
    }];
}


#pragma mark -


- (void)singleTapGestureDetected:(UIPanGestureRecognizer *)aGesture
{
    if ([aGesture state] == UIGestureRecognizerStateEnded)
    {
        CGPoint sPoint = [aGesture locationInView:[aGesture view]];
        if ([mDelegate respondsToSelector:@selector(pbView:didTapPoint:)])
        {
            [mDelegate pbView:self didTapPoint:sPoint];
        }
    }
}


- (void)longPressGestureDetected:(UIPanGestureRecognizer *)aGesture
{
    if ([aGesture state] == UIGestureRecognizerStateBegan)
    {
        CGPoint sPoint = [aGesture locationInView:[aGesture view]];
        if ([mDelegate respondsToSelector:@selector(pbView:didLongTapPoint:)])
        {
            [mDelegate pbView:self didLongTapPoint:sPoint];
        }
    }
}


#pragma mark -


- (void)beginSelectionMode
{
    [PBContext performBlock:^{
        [mRenderer beginSelectionMode];
        
        [mRenderer bindingBuffer];
        [mRenderer clearBackgroundColor:[PBColor whiteColor]];
        
        [mRenderer renderForSelection:mRenderable projection:[mCamera projection]];
    }];
}


- (void)endSelectionMode
{
    [mRenderer endSelectionMode];
}


- (PBRenderable *)selectedRenderableAtPoint:(CGPoint)aPoint
{
    aPoint.x *= [self contentScaleFactor];
    aPoint.y *= [self contentScaleFactor];

    return [mRenderer selectedRenderableAtPoint:aPoint];
}


#pragma mark -


- (CGPoint)convertPointFromView:(CGPoint)aPoint
{
    return [mCamera convertPointFromView:aPoint];
}


- (CGPoint)convertPointToView:(CGPoint)aPoint
{
    return [mCamera convertPointToView:aPoint];
}


@end
