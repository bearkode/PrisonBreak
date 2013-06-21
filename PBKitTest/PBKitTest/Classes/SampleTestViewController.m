/*
 *  SampleTestViewController.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 21..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "SampleTestViewController.h"
#import "ProfilingOverlay.h"
#import "SampleTextureViewController.h"
#import "SampleParticleViewController.h"
#import "TextureLoaderViewController.h"
#import "SoundViewController.h"
#import "FighterViewController.h"
#import "PathTestViewController.h"
#import "TextureSheetViewController.h"
#import "MapViewController.h"
#import "IsoMapViewController.h"
#import "ProfilingOverlayTestViewController.h"
#import "StressViewController.h"
#import "DynamicMeshTextureViewController.h"
#import "WaveEffectViewController.h"


@implementation SampleTestViewController
{
    UITableView *mTableView;
    NSArray     *mTestList;
}


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    
    if (self)
    {
        mTestList = [[NSArray alloc] initWithObjects:@"WaveEffectTest", @"StressTest", @"IsoMapTest", @"MapTest", @"TextureSheet", @"PathTest", @"Texture",@"UsingMeshQueue", @"Particle", @"TextureLoader", @"Sound", @"Fighter", nil];
    }
    
    return self;
}


- (void)dealloc
{
    [mTestList release];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect sBounds = [[self view] bounds];
    
    mTableView = [[[UITableView alloc] initWithFrame:sBounds style:UITableViewStylePlain] autorelease];
    [mTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [mTableView setDelegate:self];
    [mTableView setDataSource:self];
    [[self view] addSubview:mTableView];
    
    UIBarButtonItem *sProfilingButton = [[[UIBarButtonItem alloc] initWithTitle:@"Profiling"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(presentProfiling)] autorelease];
    [[self navigationItem] setRightBarButtonItem:sProfilingButton];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    mTableView = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    mTableView = nil;
}


#pragma mark -


- (void)presentProfiling
{
    ProfilingOverlayTestViewController *sViewController = [[[ProfilingOverlayTestViewController alloc] init] autorelease];
    UINavigationController *sNaviController = [[[UINavigationController alloc] initWithRootViewController:sViewController] autorelease];
    [self presentModalViewController:sNaviController animated:YES];
}


- (void)openTexture
{
    SampleTextureViewController *sViewController = [[[SampleTextureViewController alloc] init] autorelease];
    [[self navigationController] pushViewController:sViewController animated:YES];
}


- (void)openParticle
{
    SampleParticleViewController *sViewController = [[[SampleParticleViewController alloc] init] autorelease];
    [[self navigationController] pushViewController:sViewController animated:YES];
}


- (void)openTextureLoader
{
    TextureLoaderViewController *sViewController = [[[TextureLoaderViewController alloc] init] autorelease];
    [[self navigationController] pushViewController:sViewController animated:YES];
}


- (void)openSound
{
    SoundViewController *sViewController = [[[SoundViewController alloc] init] autorelease];
    [[self navigationController] pushViewController:sViewController animated:YES];
}


- (void)openFighter
{
    FighterViewController *sFighterViewController = [[[FighterViewController alloc] init] autorelease];
    [[self navigationController] pushViewController:sFighterViewController animated:YES];
}


- (void)openPathTest
{
    PathTestViewController *sViewController = [[[PathTestViewController alloc] init] autorelease];
    [[self navigationController] pushViewController:sViewController animated:YES];
}


- (void)openTextureSheet
{
    TextureSheetViewController *sViewController = [[[TextureSheetViewController alloc] init] autorelease];
    [[self navigationController] pushViewController:sViewController animated:YES];
}


- (void)openMapTest
{
    MapViewController *sViewController = [[[MapViewController alloc] init] autorelease];
    [[self navigationController] pushViewController:sViewController animated:YES];
}


- (void)openIsoMapTest
{
    IsoMapViewController *sViewController = [[[IsoMapViewController alloc] init] autorelease];
    [[self navigationController] pushViewController:sViewController animated:YES];
}

- (void)openStressTest
{
    StressViewController *sViewController = [[[StressViewController alloc] init] autorelease];
    [[self navigationController] pushViewController:sViewController animated:YES];
}


- (void)openUsingMeshQueue
{
    DynamicMeshTextureViewController *sViewController = [[[DynamicMeshTextureViewController alloc] init] autorelease];
    [[self navigationController] pushViewController:sViewController animated:YES];
}


- (void)openWaveEffectTest
{
    WaveEffectViewController *sViewController = [[[WaveEffectViewController alloc] init] autorelease];
    [[self navigationController] pushViewController:sViewController animated:YES];
}


#pragma mark - Table View Delegate / DataSource


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    return [mTestList count];;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    static NSString *sCellIdentifier = @"TestPageCell";
    
    UITableViewCell *sCell = [aTableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (sCell == nil)
    {
        sCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier] autorelease];
    }
    
    [[sCell textLabel] setText:[mTestList objectAtIndex:[aIndexPath row]]];
    
    return sCell;
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    NSString *sSelectorName = [NSString stringWithFormat:@"open%@", [mTestList objectAtIndex:[aIndexPath row]]];
    SEL       sSelector     = NSSelectorFromString(sSelectorName);

    if([self respondsToSelector:sSelector])
    {
        [self performSelector:sSelector];
    }

    [aTableView deselectRowAtIndexPath:aIndexPath animated:YES];
}


@end
