/*
 *  ProfilingOverlayTestViewController.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 2. 21..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "ProfilingOverlayTestViewController.h"
#import "ProfilingOverlay.h"


@implementation ProfilingOverlayTestViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        UIBarButtonItem *sCloseButton = [[[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(dismiss)] autorelease];
        [[self navigationItem] setLeftBarButtonItem:sCloseButton];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];

    [mAlphaSlider setMinimumValue:0.1f];
    [mAlphaSlider setMaximumValue:1.0f];
    [mAlphaSlider setValue:0.7f];
    
    ([ProfilingOverlay isHidden]) ? [[ProfilingOverlay sharedManager] stopCPUMemoryUsages] : [[ProfilingOverlay sharedManager] startCPUMemoryUsages];
    
    if ([ProfilingOverlay isHidden])
    {
        [mShowSegmant setSelectedSegmentIndex:1];
        [mAlphaSlider setEnabled:NO];
    }
    else
    {
        [mShowSegmant setSelectedSegmentIndex:0];
        [mAlphaSlider setEnabled:YES];
    }
    
    if ([ProfilingOverlay isTop])
    {
        [mPositionSegmant setSelectedSegmentIndex:0];
    }
    else
    {
        [mPositionSegmant setSelectedSegmentIndex:1];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -


- (void)dismiss
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -


- (IBAction)alphaChanged:(id)aSender
{
    UISlider *sSlider = (UISlider *)aSender;
    [ProfilingOverlay setAlpha:[sSlider value]];
}

- (IBAction)positionSelected:(id)aSender
{
    UISegmentedControl *sSegment = (UISegmentedControl *)aSender;    
    if (sSegment.selectedSegmentIndex == 0) // up
    {
        [ProfilingOverlay setTop:YES];
    }
    else // bottom
    {
        [ProfilingOverlay setTop:NO];
    }
}

- (IBAction)showSelected:(id)aSender
{
    UISegmentedControl *sSegment = (UISegmentedControl *)aSender;    
    if (sSegment.selectedSegmentIndex == 0) // show
    {
        [ProfilingOverlay setHidden:NO];
        [[ProfilingOverlay sharedManager] startCPUMemoryUsages];
        [mAlphaSlider setEnabled:YES];
    }
    else // hide
    {
        [ProfilingOverlay setHidden:YES];
        [[ProfilingOverlay sharedManager] stopCPUMemoryUsages];
        [mAlphaSlider setEnabled:NO];
    }
}


@end
