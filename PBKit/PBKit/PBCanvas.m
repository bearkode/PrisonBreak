/*
 *  PBCanvas.m
 *  PBKit
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012 PrisonBreak. All rights reserved.
 *
 */

#import "PBKit.h"


@implementation PBCanvas
{
    id                 mDelegate;
    PBDisplayFrameRate mDisplayFrameRate;
    CADisplayLink     *mDisplayLink;
    PBCamera          *mCamera;
    PBRenderer        *mRenderer;
    PBRenderable      *mRenderable;
    PBColor           *mBackgroundColor;
    
    NSInteger          mFPS;
    CFTimeInterval     mFPSLastTimestamp;
    CFTimeInterval     mTimeInterval;
    CFTimeInterval     mTimeLastTimestamp;
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

    mDisplayFrameRate = kPBDisplayFrameRateMid;
 
    [mRenderable autorelease];
    [mRenderer autorelease];

    mRenderable = [[PBRenderable alloc] init];
    [mRenderable setName:@"PBCanvas Renderable"];
    mRenderer   = [[PBRenderer alloc] init];
    mCamera     = [[PBCamera alloc] init];

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
    
    [mRenderable release];
    [mRenderer release];
    [mCamera release];
    [mBackgroundColor release];
    
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
            if (CGSizeEqualToSize([mCamera viewSize], sOldSize))
            {
                [mCamera setViewSize:sNewSize];
            }
            
            [mRenderer resetRenderBufferWithLayer:(CAEAGLLayer *)[self layer]];
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


- (void)updateTimeInterval:(CADisplayLink *)aDisplayLink
{
    CFTimeInterval sCurrTimestamp = [aDisplayLink timestamp];
    mTimeInterval                 = (mTimeLastTimestamp == 0) ? 0 : (sCurrTimestamp - mTimeLastTimestamp);;
    mTimeLastTimestamp            = sCurrTimestamp;
}


- (CFTimeInterval)timeInterval
{
    return mTimeInterval;
}


- (void)updateFPS
{
    CFTimeInterval sCurrTimestamp      = CFAbsoluteTimeGetCurrent();
    float          sDeltaTimeInSeconds = sCurrTimestamp - mFPSLastTimestamp;
    mFPS                               = (sDeltaTimeInSeconds == 0) ? 0: 1 / (sDeltaTimeInSeconds);
    mFPSLastTimestamp                  = sCurrTimestamp;
}


- (NSInteger)fps
{
    return mFPS;
}



#pragma mark -


- (void)update:(CADisplayLink *)aDisplayLink
{    
    [self updateTimeInterval:aDisplayLink];
    [self updateFPS];
    
    [mRenderer bindBuffer];
    [mRenderer clearBackgroundColor:mBackgroundColor];
    
    id sDelegate = (mDelegate) ? mDelegate : self;
    if ([sDelegate respondsToSelector:@selector(pbCanvasUpdate:)])
    {
        [sDelegate pbCanvasUpdate:self];
    }
    
    [mRenderable setProjection:[mCamera projection]];
    [mRenderer render:mRenderable];
    
    
//    NSLog(@"current fps = %d, current timeinterval = %f", [self fps], [self timeInterval]);
}


#pragma mark -


- (void)singleTapGestureDetected:(UIPanGestureRecognizer *)aGesture
{
    if ([aGesture state] == UIGestureRecognizerStateEnded)
    {
        CGPoint sPoint = [aGesture locationInView:[aGesture view]];
        id sDelegate = (mDelegate) ? mDelegate : self;
        if ([sDelegate respondsToSelector:@selector(pbCanvas:didTapPoint:)])
        {
            [sDelegate pbCanvas:self didTapPoint:sPoint];
        }
    }
}


- (void)longPressGestureDetected:(UIPanGestureRecognizer *)aGesture
{
    if ([aGesture state] == UIGestureRecognizerStateBegan)
    {
        CGPoint sPoint = [aGesture locationInView:[aGesture view]];
        id sDelegate = (mDelegate) ? mDelegate : self;
        if ([sDelegate respondsToSelector:@selector(pbCanvas:didLongTapPoint:)])
        {
            [sDelegate pbCanvas:self didLongTapPoint:sPoint];
        }
    }
}


#pragma mark -


- (void)beginSelectionMode
{
    [mRenderer beginSelectionMode];

    [mRenderer bindBuffer];
    [mRenderer clearBackgroundColor:[PBColor whiteColor]];

    [mRenderable setProjection:[mCamera projection]];
    [mRenderer renderForSelection:mRenderable];
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


- (CGPoint)convertPointToCanvas:(CGPoint)aPoint
{
    return [mCamera convertPointToCanvas:aPoint];
}


- (CGPoint)convertPointToView:(CGPoint)aPoint
{
    return [mCamera convertPointToView:aPoint];
}


@end
