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
    
    [mCamera addObserver:self forKeyPath:@"position" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
    [mCamera addObserver:self forKeyPath:@"zoomScale" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
    
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
    CGPoint sPosition  = [mCamera position];
    CGFloat sZoomScale = [mCamera zoomScale];
    GLfloat sDisplayWidth  = (GLfloat)[mRenderer displayWidth];
    GLfloat sDisplayHeight = (GLfloat)[mRenderer displayHeight];
    
    GLfloat sLeft   = -(sDisplayWidth / 2 / sZoomScale) + sPosition.x;
    GLfloat sRight  = (sDisplayWidth / 2 / sZoomScale) + sPosition.x;
    GLfloat sBottom = -(sDisplayHeight / 2 / sZoomScale) + sPosition.y;
    GLfloat sTop    = (sDisplayHeight / 2 / sZoomScale) + sPosition.y;
    
    PBMatrix4 sMatrix = [PBTransform multiplyOrthoMatrix:PBMatrix4Identity
                                                    left:sLeft
                                                   right:sRight
                                                  bottom:sBottom
                                                     top:sTop
                                                    near:-1000 far:1000];
    [mRenderer setProjectionMatrix:sMatrix];
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
        if ([aKeyPath isEqualToString:@"position"] || [aKeyPath isEqualToString:@"zoomScale"])
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
        
        [mRenderer render:mRenderable];
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
        
        [mRenderer renderForSelection:mRenderable];
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


@end
