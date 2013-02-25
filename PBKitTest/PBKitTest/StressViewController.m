/*
 *  StressViewController.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 2. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "StressViewController.h"
#import "ProfilingOverlay.h"


#define kDefaultRenderableCount 500
#define kRenderableMaxCount     2000
#define kCanvasGap              40


@implementation StressViewController
{
    PBCanvas       *mCanvas;
    NSMutableArray *mRenderables;
    PBVertex3       mAngle;
    CGFloat         mScale;
}


#pragma mark -


- (void)updateCount:(NSInteger)aCount
{
    [self setTitle:[NSString stringWithFormat:@"Renderable Count : %d", aCount]];
 
    CGRect    sBounds = [mCanvas bounds];
    [[mCanvas camera] setPosition:CGPointMake(sBounds.size.width / 2 - kCanvasGap, sBounds.size.height / 2 - kCanvasGap)];

    [mRenderables removeAllObjects];
    
    for (NSInteger i = 0; i < aCount; i++)
    {
        NSInteger x = (arc4random() % 24);
        NSInteger y = (arc4random() % 19);
        
        NSString *sImageName = [NSString stringWithFormat:@"poket%02d%02d", x, y];
        PBSprite *sSprite    = [[[PBSprite alloc] initWithImageName:sImageName] autorelease];
        CGPoint sPosition    = CGPointMake((arc4random() % (int)(sBounds.size.width - (kCanvasGap * 2))), (arc4random() % (int)(sBounds.size.height - (kCanvasGap * 2))));
        
        [sSprite setTransform:[[[PBTransform alloc] init] autorelease]];
        [sSprite setName:sImageName];
        [sSprite setPosition:sPosition];
        [mRenderables addObject:sSprite];
    }
   
    [[mCanvas renderable] setSubrenderables:mRenderables];
}


#pragma mark -


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    if (self)
    {
        mRenderables = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [PBTextureInfoManager vacate];
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    [mRenderables release];
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect sBounds = [[self view] bounds];
    
    mCanvas = [[[PBCanvas alloc] initWithFrame:sBounds] autorelease];
    [mCanvas setBackgroundColor:[PBColor grayColor]];
    [mCanvas setDelegate:self];
    [mCanvas setAutoresizingMask:UIViewAutoresizingFlexibleHeight];

    [[self view] addSubview:mCanvas];
    [[self view] sendSubviewToBack:mCanvas];
    
    [mCountSlide setMinimumValue:1];
    [mCountSlide setMaximumValue:kRenderableMaxCount];
    [mCountSlide setValue:kDefaultRenderableCount];
    [self updateCount:kDefaultRenderableCount];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];
    
    [mCanvas startDisplayLoop];
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
    
    [mCanvas stopDisplayLoop];
}


#pragma mark -


- (IBAction)countChanged:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    [self updateCount:[sSlider value]];
}


#pragma mark -


- (void)pbCanvasUpdate:(PBCanvas *)aView
{
    [[ProfilingOverlay sharedManager] displayFPS:[aView fps] timeInterval:[aView timeInterval]];
    
    for (PBSprite *sSprite in mRenderables)
    {
        mScale = (arc4random() % 10) * 0.1;
        [[sSprite transform] setAngle:mAngle];
        [[sSprite transform] setScale:mScale];
    }
    mAngle.z += 30;
}


@end
