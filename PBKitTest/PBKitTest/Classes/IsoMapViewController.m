/*
 *  IsoMapViewController.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 2. 21..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "IsoMapViewController.h"
#import "IsoMap.h"


@implementation IsoMapViewController
{
    IsoMap   *mMap;
    PBSprite *mOrigin;
}


#pragma mark -


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];

    if (self)
    {
        NSString *sPath = [[NSBundle mainBundle] pathForResource:@"isomap" ofType:@"json"];
        mMap = [[IsoMap alloc] initWithContentsOfFile:sPath];
        
        mOrigin = [[PBSprite alloc] initWithImageName:@"cross"];
    }
    
    return self;
}


- (void)dealloc
{
    [mMap release];
    [mOrigin release];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    
    PBCanvas *sCanvas = [self canvas];
    
    [sCanvas setBackgroundColor:[PBColor grayColor]];
    [[sCanvas renderable] addSubrenderable:mMap];
    [[sCanvas renderable] addSubrenderable:mOrigin];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    NSLog(@"viewDidAppear");
    [super viewDidAppear:aAnimated];
    
//    CGRect sBounds = [[self view] bounds];
//    [[mCanvas camera] setPosition:CGPointMake(sBounds.size.width / 2, sBounds.size.height / 2)];
}





@end
