/*
 *  PBCanvas.m
 *  PBKit
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012 PrisonBreak. All rights reserved.
 *
 */


#import "PBContext.h"
#import "PBCanvas.h"
#import "PBCamera.h"
#import "PBRenderer.h"
#import "PBException.h"
#import "PBProgramManager.h"
#import "PBProgram.h"
#import "PBColor.h"
#import "PBScene.h"
#import "PBNodePrivate.h"


@implementation PBCanvas
{
    PBDisplayFrameRate mDisplayFrameRate;
    CADisplayLink     *mDisplayLink;
    PBCamera          *mCamera;
    PBRenderer        *mRenderer;
    PBColor           *mBackgroundColor;
    PBScene           *mScene;

    NSInteger          mFPS;
    CFTimeInterval     mFPSLastTimestamp;
    CFTimeInterval     mTimeInterval;
    CFTimeInterval     mTimeLastTimestamp;
}


@synthesize backgroundColor = mBackgroundColor;
@synthesize renderer        = mRenderer;
@synthesize camera          = mCamera;


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
    [mRenderer autorelease];
    mRenderer = [[PBRenderer alloc] init];
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


- (void)setupGestureEvent
{
    UITapGestureRecognizer *sGestureSingleTap       = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureDetected:)] autorelease];
    [sGestureSingleTap setDelegate:self];
    [sGestureSingleTap setNumberOfTapsRequired:1];
    [self addGestureRecognizer:sGestureSingleTap];
    
    UILongPressGestureRecognizer *sLongPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureDetected:)] autorelease];
    [sLongPressGesture setDelegate:self];
    [self addGestureRecognizer:sLongPressGesture];
}


- (void)setup
{
    mDisplayFrameRate = kPBDisplayFrameRateMid;
    
    [self setupLayer];
    [self setupRenderer];
    [self setupCamera];
    [self setupShader];
    [self setupGestureEvent];
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
    
    [mScene release];
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
            [mScene setSceneSize:[mRenderer renderBufferSize]];
            [mScene resetRenderBuffer];
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


- (void)presentScene:(PBScene *)aScene
{
    [mScene autorelease];
    mScene = [aScene retain];

    if (![mScene isGeneratedBuffer])
    {
        [mScene setSceneSize:[mRenderer renderBufferSize]];
        [mScene resetRenderBuffer];
        [[mScene mesh] setProjection:[mCamera projection]];
    }
}


- (void)presentScene:(PBScene *)aScene withTransition:(PBSceneTransition)aTransition
{
    NSLog(@"presentScene:withTransition: not implemented.");
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
    if (!mScene)
    {
        return;
    }

    [self updateTimeInterval:aDisplayLink];
    [self updateFPS];

    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        [PBContext performBlock:^{
        
            [mScene performSceneDelegatePhase:kPBSceneDelegatePhaseWillUpdate];
            
            if ([mCamera didProjectionChange])
            {
                [[mScene mesh] setProjection:[mCamera projection]];
            }

            [mRenderer clearBackgroundColor:mBackgroundColor withScene:mScene];
            [mRenderer renderScene:mScene];
            [mRenderer renderScreenForScene:mScene];

            [mScene performSceneDelegatePhase:kPBSceneDelegatePhaseWillRender];
            [mRenderer presentRenderBuffer];
            [mScene performSceneDelegatePhase:kPBSceneDelegatePhaseDidRender];
            
            [mScene performSceneDelegatePhase:kPBSceneDelegatePhaseDidUpdate];
        }];
    }
}


#pragma mark -


- (void)singleTapGestureDetected:(UITapGestureRecognizer *)aGesture
{
    if ([aGesture state] == UIGestureRecognizerStateEnded)
    {
        CGPoint sViewPoint   = [aGesture locationInView:[aGesture view]];
        CGPoint sCanvasPoint = [self canvasPointFromViewPoint:sViewPoint];
        
        [mScene performSceneTapDelegatePhase:kPBSceneTapDelegatePhaseTap canvasPoint:sCanvasPoint];
    }
}


- (void)longPressGestureDetected:(UILongPressGestureRecognizer *)aGesture
{
    if ([aGesture state] == UIGestureRecognizerStateBegan)
    {
        CGPoint sViewPoint   = [aGesture locationInView:[aGesture view]];
        CGPoint sCanvasPoint = [self canvasPointFromViewPoint:sViewPoint];
        
        [mScene performSceneTapDelegatePhase:kPBSceneTapDelegatePhaseLongTap canvasPoint:sCanvasPoint];
    }
}


#pragma mark -


- (void)beginSelectionMode
{
    if (!mScene)
    {
        NSAssert(NO, @"PBScene is nil.");
        return;
    }
    
    [mRenderer beginSelectionMode];
    [mRenderer clearBackgroundColor:[PBColor whiteColor] withScene:nil];
    [mRenderer renderForSelectionScene:mScene];
}


- (void)endSelectionMode
{
    [mRenderer endSelectionMode];
}


- (PBNode *)selectedNodeAtPoint:(CGPoint)aPoint
{
    aPoint.x *= [self contentScaleFactor];
    aPoint.y *= [self contentScaleFactor];

    return [mRenderer selectedNodeAtPoint:aPoint];
}


#pragma mark -


- (CGPoint)canvasPointFromViewPoint:(CGPoint)aPoint
{
    return [mCamera convertPointToCanvas:aPoint];
}


- (CGPoint)viewPointFromCanvasPoint:(CGPoint)aPoint
{
    return [mCamera convertPointToView:aPoint];
}


@end
