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
    PBLayer           *mRootLayer;
    PBColor           *mBackgroundColor;
    
    NSInteger          mFPS;
    CFTimeInterval     mFPSLastTimestamp;
    CFTimeInterval     mTimeInterval;
    CFTimeInterval     mTimeLastTimestamp;
}


@synthesize delegate        = mDelegate;
@synthesize backgroundColor = mBackgroundColor;
@synthesize rootLayer       = mRootLayer;
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


- (void)setupLayer
{
    CAEAGLLayer  *sLayer      = (CAEAGLLayer *)[self layer];
    NSDictionary *sProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
                                                                           kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
    [sLayer setDrawableProperties:sProperties];
    [sLayer setOpaque:[self isOpaque]];
    [sLayer addObserver:self forKeyPath:@"bounds" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
    [EAGLContext setCurrentContext:[PBContext context]];
}


- (void)setupRenderer
{
    [mRootLayer autorelease];
    mRootLayer = [[PBLayer alloc] init];
    [mRootLayer setName:@"PBCanvas Root Layer"];
 
    [mRenderer autorelease];
    mRenderer   = [[PBRenderer alloc] init];
}


- (void)setupCamera
{
    [mCamera autorelease];
    mCamera = [[PBCamera alloc] init];
    [mCamera setViewSize:[self bounds].size];

    [mRenderer resetRenderBufferWithLayer:(CAEAGLLayer *)[self layer]];
}

- (void)setupShader
{
    PBProgram *sProgram = [[PBProgramManager sharedManager] program];
    [sProgram use];
}


- (void)setup
{
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    mDisplayFrameRate = kPBDisplayFrameRateMid;
    
    [self setupLayer];
    [self setupRenderer];
    [self setupCamera];
    [self setupShader];
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
    
    [mRootLayer release];
    [mRenderer release];
    [mCamera release];
    [mBackgroundColor release];
    
    [super dealloc];
}


- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)aObject change:(NSDictionary *)aChange context:(void *)aContext
{
    if ((aObject == [self layer]) && [aKeyPath isEqualToString:@"bounds"])
    {
        CGSize sOldSize = [[aChange objectForKey:NSKeyValueChangeOldKey] CGRectValue].size;
        CGSize sNewSize = [[aChange objectForKey:NSKeyValueChangeNewKey] CGRectValue].size;
        
        if (!CGSizeEqualToSize(sOldSize, sNewSize))
        {
            [mCamera setViewSize:sNewSize];
            [mRenderer resetRenderBufferWithLayer:(CAEAGLLayer *)[self layer]];
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

    [PBContext performBlockOnMainThread:^{
        
        [mRenderer bindBuffer];
        [mRenderer clearBackgroundColor:mBackgroundColor];
        
        if ([mDelegate respondsToSelector:@selector(pbCanvasUpdate:)])
        {
            [mDelegate pbCanvasUpdate:self];
        }

        [mRenderer setProjection:[mCamera projection]];
        [mRenderer render:mRootLayer];
    }];
}


#pragma mark -


- (void)singleTapGestureDetected:(UIPanGestureRecognizer *)aGesture
{
    if ([aGesture state] == UIGestureRecognizerStateEnded)
    {
        CGPoint sPoint = [aGesture locationInView:[aGesture view]];

        if ([mDelegate respondsToSelector:@selector(pbCanvas:didTapPoint:)])
        {
            [mDelegate pbCanvas:self didTapPoint:sPoint];
        }
    }
}


- (void)longPressGestureDetected:(UIPanGestureRecognizer *)aGesture
{
    if ([aGesture state] == UIGestureRecognizerStateBegan)
    {
        CGPoint sPoint = [aGesture locationInView:[aGesture view]];

        if ([mDelegate respondsToSelector:@selector(pbCanvas:didLongTapPoint:)])
        {
            [mDelegate pbCanvas:self didLongTapPoint:sPoint];
        }
    }
}


#pragma mark -


- (void)beginSelectionMode
{
    [mRenderer beginSelectionMode];

    [mRenderer bindBuffer];
    [mRenderer clearBackgroundColor:[PBColor whiteColor]];

//    [mRootLayer setProjection:[mCamera projection]];
    [mRenderer renderForSelection:mRootLayer];
}


- (void)endSelectionMode
{
    [mRenderer endSelectionMode];
}


- (PBLayer *)selectedLayerAtPoint:(CGPoint)aPoint
{
    aPoint.x *= [self contentScaleFactor];
    aPoint.y *= [self contentScaleFactor];

    return [mRenderer selectedLayerAtPoint:aPoint];
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
