/*
 *  AtlasViewController.m
 *  PBKitTest
 *
 *  Created by cgkim on 13. 8. 28..
 *  Copyright (c) 2013 NHN. All rights reserved.
 *
 */

#import "AtlasViewController.h"


@implementation AtlasViewController


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    
    if (self)
    {

    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"begin generating");
    
    PBAtlas *sAtlas = [PBAtlas atlas];
    [sAtlas addImage:[UIImage imageNamed:@"airship"] forKey:@"airship"];
    [sAtlas addImage:[UIImage imageNamed:@"icon"] forKey:@"icon"];
    [sAtlas addImage:[UIImage imageNamed:@"coin"] forKey:@"coin"];
    [sAtlas addImage:[UIImage imageNamed:@"brown"] forKey:@"brown"];
    [sAtlas addImage:[UIImage imageNamed:@"tornado1"] forKey:@"tornado1"];
    [sAtlas addImage:[UIImage imageNamed:@"cross"] forKey:@"cross"];
    [sAtlas addImage:[UIImage imageNamed:@"balloon"] forKey:@"balloon"];
    [sAtlas addImage:[UIImage imageNamed:@"poket0000"] forKey:@"poket0000"];
    [sAtlas addImage:[UIImage imageNamed:@"poket0003"] forKey:@"poket0003"];
    [sAtlas addImage:[UIImage imageNamed:@"poket0004"] forKey:@"poket0004"];
    [sAtlas addImage:[UIImage imageNamed:@"poket0006"] forKey:@"poket0006"];
    [sAtlas addImage:[UIImage imageNamed:@"poket0007"] forKey:@"poket0007"];
    [sAtlas generate];
    
    NSLog(@"end generating");
    NSLog(@"atlas size - %f", [sAtlas size].width);
    
    UIImageView *sImageView = [[[UIImageView alloc] initWithFrame:[[self view] bounds]] autorelease];
    [[self view] addSubview:sImageView];
    [sImageView setContentMode:UIViewContentModeScaleAspectFit];
    [sImageView setImage:[sAtlas atlasImage]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
