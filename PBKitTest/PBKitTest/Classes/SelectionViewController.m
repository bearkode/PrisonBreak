/*
 *  SelectionViewController.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 2. 28..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SelectionViewController.h"
#import <PBKit.h>
#import "ProfilingOverlay.h"
#import "BasicParticle.h"


#pragma mark - PoketData


@interface PoketData : NSObject
{
    PBSprite *mSprite;
    NSInteger mSpeed;
    BOOL      mDirection;
}


@property (nonatomic, retain) PBSprite *sprite;
@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, assign) BOOL      direction;
@end


@implementation PoketData


@synthesize sprite    = mSprite;
@synthesize speed     = mSpeed;
@synthesize direction = mDirection;


- (void)dealloc
{
    [mSprite release];
    
    [super dealloc];
}


@end


#pragma mark - SelectionViewController


@implementation SelectionViewController
{
    NSMutableArray *mPokets;
    NSMutableArray *mFirePokets;
}


#pragma mark -


- (void)clearParticles
{
    NSArray *sFirePokets = [mFirePokets copy];
    for (NSInteger i = 0; i < [sFirePokets count]; i++)
    {
        BasicParticle *sParticle = [sFirePokets objectAtIndex:i];
        [sParticle finished];
    }
    [sFirePokets release];
}


#pragma mark -


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[self view] setBackgroundColor:[UIColor darkGrayColor]];
        
        mPokets     = [[NSMutableArray alloc] init];
        mFirePokets = [[NSMutableArray alloc] init];
        
        CGPoint sPosition = CGPointMake(-100, 150);
        for (NSInteger i = 0; i < 5; i++)
        {
            NSInteger sSpeed = (arc4random() % 5) + 1;
            NSString *sImageName = @"airship";

            PoketData *sPoket = [[[PoketData alloc] init] autorelease];
            [sPoket setSprite:[[[PBSprite alloc] initWithImageName:sImageName] autorelease]];
            [sPoket setSpeed:sSpeed];

            [[sPoket sprite] setSelectable:YES];
            [[sPoket sprite] setName:sImageName];
            [[sPoket sprite] setPoint:sPosition];
            [mPokets addObject:sPoket];
            
            sPosition.y -= 70;
            sPosition.x += 55;
            
            [[[self canvas] rootLayer] addSublayer:[sPoket sprite]];
        }
    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
 
    [[self canvas] setDelegate:nil];
    [mPokets release];
    [mFirePokets release];
    
    [PBMeshArrayPool vacate];
    [PBTextureManager vacate];
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self canvas] setBackgroundColor:[PBColor darkGrayColor]];
    [[self canvas] setDelegate:self];
    [[self canvas] registGestureEvent];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
    
    [self clearParticles];
}


#pragma mark -


- (void)firePoket:(PBLayer *)aFireLayer startCoordinate:(CGPoint)aStartCoordinate count:(NSUInteger)aCount speed:(CGFloat)aSpeed
{
    PBTexture *sTexture = [[[PBTexture alloc] initWithImageName:[aFireLayer name]] autorelease];
    [sTexture loadIfNeeded];

    BasicParticle *sFirePoket = [[[BasicParticle alloc] initWithTexture:sTexture] autorelease];
    [sFirePoket setParticleCount:aCount];
    [sFirePoket setSpeed:aSpeed];
    [sFirePoket setPlaybackBlock:^() {
        [mFirePokets removeObject:sFirePoket];
    }];
    [mFirePokets addObject:sFirePoket];
    [sFirePoket fire:aStartCoordinate];
}


#pragma mark -


- (void)pbCanvasWillUpdate:(PBCanvas *)aView
{
    [[ProfilingOverlay sharedManager] displayFPS:[aView fps] timeInterval:[aView timeInterval]];
    
    CGRect sBound = [[self canvas] bounds];
    for (PoketData *sPoket in mPokets)
    {
        PBSprite *sSprite   = [sPoket sprite];
        CGPoint   sPosition = [sSprite point];
        
        if (![sPoket direction]) // left -> right
        {
            if (sPosition.x > (sBound.size.width / 2))
            {
                [sPoket setDirection:YES];
                sPosition.x -= [sPoket speed];
            }
            else
            {
                sPosition.x += [sPoket speed];
            }
        }
        else // right -> left
        {
            if (sPosition.x < -(sBound.size.width / 2))
            {
                [sPoket setDirection:NO];
                sPosition.x += [sPoket speed];
            }
            else
            {
                sPosition.x -= [sPoket speed];
            }
        }
        
        [sSprite setPoint:sPosition];
    }
    
    for (NSInteger i = 0; i < [mFirePokets count]; i++)
    {
        BasicParticle *sParticle = [mFirePokets objectAtIndex:i];
        [sParticle draw];
    }
}


- (void)pbCanvasDidUpdate:(PBCanvas *)aView
{
    
}


- (void)pbCanvas:(PBCanvas *)aCanvas didTapPoint:(CGPoint)aPoint
{
    [aCanvas beginSelectionMode];

    PBLayer *sSelectedLayer = [aCanvas selectedLayerAtPoint:aPoint];
    if (sSelectedLayer)
    {
        CGPoint sCanvasTapPoint = [aCanvas canvasPointFromViewPoint:aPoint];
        CGSize  sSize = [[aCanvas camera] viewSize];
        CGPoint sParticleCoord = CGPointMake((sCanvasTapPoint.x / (sSize.width / 2)), (sCanvasTapPoint.y / (sSize.height / 2)));
        [self firePoket:sSelectedLayer startCoordinate:sParticleCoord count:500 speed:0.01];
    }
    [aCanvas endSelectionMode];
}


@end
