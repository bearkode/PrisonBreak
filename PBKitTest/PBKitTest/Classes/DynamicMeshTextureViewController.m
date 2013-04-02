/*
 *  DynamicMeshTextureViewController.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 3. 29..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "DynamicMeshTextureViewController.h"
#import "ProfilingOverlay.h"
#import <PBKit.h>



@implementation DynamicMeshTextureViewController


#pragma mark -


- (void)setupLayers
{
    PBSprite *sSprite = nil;
    
    sSprite = [[[PBSprite alloc] initWithImageName:@"poket0119"] autorelease];
    [sSprite setPoint:CGPointMake(80, 80)];
//    [[sSprite mesh] setDynamicDraw:YES];
    [[[self canvas] rootLayer] addSublayer:sSprite];
    
    NSInteger sLayerCount = 10;
    CGPoint   sPoint      = CGPointMake(-100, 0);
    for (NSInteger i = 0; i < sLayerCount; i++)
    {
        sSprite = [[[PBSprite alloc] initWithImageName:@"airship"] autorelease];
        [sSprite setPoint:sPoint];
        [[sSprite mesh] setUsingMeshQueue:YES];
        [[[self canvas] rootLayer] addSublayer:sSprite];
        
        sPoint.x += 20;
    }
    
    sSprite = [[[PBSprite alloc] initWithImageName:@"poket0118"] autorelease];
    [sSprite setPoint:CGPointMake(90, -80)];
//    [[sSprite mesh] setDynamicDraw:YES];
    [[[self canvas] rootLayer] addSublayer:sSprite];
}


#pragma mark -


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[self view] setBackgroundColor:[UIColor underPageBackgroundColor]];
    }
    return self;
}


- (void)dealloc
{
    [[ProfilingOverlay sharedManager] stopDisplayFPS];
    [PBMeshArrayPool vacate];
    [PBTextureManager vacate];
    [[self canvas] setDelegate:nil];
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self canvas] setFrame:CGRectMake(0, 0, 320, 300)];
    [[self canvas] setBackgroundColor:[PBColor lightGrayColor]];
    [[self canvas] setDelegate:self];
    
    
    [self setupLayers];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -


- (void)pbCanvasWillUpdate:(PBCanvas *)aView
{
    [[ProfilingOverlay sharedManager] displayFPS:[aView fps] timeInterval:[aView timeInterval]];

}

@end
