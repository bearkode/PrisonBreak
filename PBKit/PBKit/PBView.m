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
    id                 mDisplayDelegate;
    PBDisplayFrameRate mDisplayFrameRate;
    CADisplayLink     *mDisplayLink;
    CFTimeInterval     mLastTimestamp;
    
    PBCamera          *mCamera;
    PBRenderer        *mRenderer;
    
    PBRenderable      *mRenderable;
    NSMutableArray    *mSelectableRenderable;
    
    PBColor           *mBackgroundColor;
}


@synthesize displayDelegate = mDisplayDelegate;
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
 
    [mSelectableRenderable autorelease];
    [mRenderable autorelease];
    [mRenderer autorelease];
    
    mSelectableRenderable = [[NSMutableArray alloc] init];
    mRenderable           = [[PBRenderable alloc] init];
    mRenderer             = [[PBRenderer alloc] init];
    mCamera               = [[PBCamera alloc] init];
    
    [mCamera addObserver:self forKeyPath:@"position" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
    
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
    
    [PBContext performBlock:^{
        [mRenderable release];
        [mRenderer release];
        [mCamera release];
        
        [mBackgroundColor release];
        [mSelectableRenderable release];
    }];
    
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
            [PBContext performBlock:^{
                [mRenderer resetRenderBufferWithLayer:(CAEAGLLayer *)[self layer]];
            }];
        }
    }
    else if ((aObject == mCamera) && [aKeyPath isEqualToString:@"position"])
    {
        CGPoint sPosition = [mCamera position];
        
        NSLog(@"sPosition = %@", NSStringFromCGPoint(sPosition));
        
        GLfloat sDisplayWidth  = (GLfloat)[mRenderer displayWidth];
        GLfloat sDisplayHeight = (GLfloat)[mRenderer displayHeight];
        
        NSLog(@"sDisplayWidth = %f", sDisplayWidth);
        NSLog(@"sDisplayHeight = %f", sDisplayHeight);
        
        GLfloat sLeft   = -(sDisplayWidth / 2) + sPosition.x;
        GLfloat sRight  = (sDisplayWidth / 2) + sPosition.x;
        GLfloat sBottom = -(sDisplayHeight / 2) + sPosition.y;
        GLfloat sTop    = (sDisplayHeight / 2) + sPosition.y;
        
        NSLog(@"left = %f, right = %f, bottom = %f, top = %f", sLeft, sRight, sBottom, sTop);

        PBMatrix4 sMatrix = [PBTransform multiplyOrthoMatrix:PBMatrix4Identity
                                                        left:sLeft
                                                       right:sRight
                                                      bottom:sBottom
                                                         top:sTop
                                                        near:-1000 far:1000];
        [mRenderer setProjectionMatrix:sMatrix];
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
