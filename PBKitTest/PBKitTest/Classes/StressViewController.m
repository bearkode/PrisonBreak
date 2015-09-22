/*
 *  StressViewController.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 2. 21..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "StressViewController.h"
#import "ProfilingOverlay.h"


#define kDefaultNodeCount 500
#define kNodeMaxCount     2000
#define kCanvasGap        40


@implementation StressViewController
{
    PBCanvas       *mCanvas;
    PBScene        *mScene;
    NSMutableArray *mNodes;
    PBVertex3       mAngle;
    PBVertex3       mScale;
}


#pragma mark -


- (void)updateCount:(NSInteger)aCount
{
    [self setTitle:[NSString stringWithFormat:@"Node Count : %d", (int)aCount]];
 
    CGRect    sBounds = [mCanvas bounds];
    [[mCanvas camera] setPosition:CGPointMake(sBounds.size.width / 2 - kCanvasGap, sBounds.size.height / 2 - kCanvasGap)];

    [mNodes removeAllObjects];
    
    for (NSInteger i = 0; i < aCount; i++)
    {
        NSInteger x = (arc4random() % 24);
        NSInteger y = (arc4random() % 19);
        
        NSString     *sImageName  = [NSString stringWithFormat:@"poket%02d%02d", (int)x, (int)y];
        PBSpriteNode *sSpriteNode = [[[PBSpriteNode alloc] initWithImageNamed:sImageName] autorelease];
        CGPoint       sPosition   = CGPointMake((arc4random() % (int)(sBounds.size.width - (kCanvasGap * 2))), (arc4random() % (int)(sBounds.size.height - (kCanvasGap * 2))));
        
        [sSpriteNode setName:sImageName];
        [sSpriteNode setPoint:sPosition];
        [mNodes addObject:sSpriteNode];
    }
   
    [mScene setSubNodes:mNodes];
}


#pragma mark -


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    if (self)
    {
        mNodes = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [PBTextureManager vacate];
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    [mNodes release];
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect sBounds = [[self view] bounds];
    
    mCanvas = [[[PBCanvas alloc] initWithFrame:sBounds] autorelease];
    [mCanvas setBackgroundColor:[PBColor grayColor]];
    
    mScene = [[[PBScene alloc] initWithDelegate:self] autorelease];
    [mCanvas presentScene:mScene];
    
    [mCanvas setAutoresizingMask:UIViewAutoresizingFlexibleHeight];

    [[self view] addSubview:mCanvas];
    [[self view] sendSubviewToBack:mCanvas];
    
    [mCountSlide setMinimumValue:1];
    [mCountSlide setMaximumValue:kNodeMaxCount];
    [mCountSlide setValue:kDefaultNodeCount];
    [self updateCount:kDefaultNodeCount];
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


- (void)pbSceneWillUpdate:(PBScene *)aScene
{
    [[ProfilingOverlay sharedManager] displayFPS:[mCanvas fps] timeInterval:[mCanvas timeInterval]];
    
//    for (PBSpriteNode *sSprite in mNodes)
//    {
//        CGFloat sScaleFactor = (arc4random() % 10) * 0.1;
//        [sSprite setAngle:mAngle];
//        [sSprite setScale:PBVertex3Make(sScaleFactor, sScaleFactor, 1.0f)];
//    }
//    mAngle.z += 30;
}


@end
