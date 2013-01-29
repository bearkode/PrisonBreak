/*
 *  SampleTestViewController.m
 *  PBKitTest
 *
 *  Created by sshanks on 13. 1. 21..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import "SampleTestViewController.h"
#import "SampleTextureViewController.h"
#import "SampleParticleViewController.h"
#import "SoundViewController.h"


@implementation SampleTestViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {

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
    
    [mTableView setBackgroundColor:[UIColor clearColor]];
    mTestList = [[NSArray alloc] initWithObjects:@"Texture", @"Particle", @"Sound", nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -


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


- (void)openSound
{
    SoundViewController *sViewController = [[[SoundViewController alloc] init] autorelease];
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
