/*
 *  TextureSheetViewController.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 2. 4..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "TextureSheetViewController.h"
#import "PBKit.h"
#import "IndexTexture.h"


@implementation TextureSheetViewController
{
    PBView       *mView;

    PBRenderable *mBoom;
    PBRenderable *mIndexLabel;
    
    NSInteger     mTextureIndex;
}


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
    [mBoom release];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mView = [[[PBView alloc] initWithFrame:[[self view] bounds]] autorelease];
    [mView setDisplayDelegate:self];
    [mView setBackgroundColor:[PBColor blackColor]];
    
    if (!mBoom)
    {
        mTextureIndex = 0;
        
        PBTexture *sTexture = [[PBTexture textureNamed:@"exp1.png"] load];
        [sTexture setTileSize:CGSizeMake(64, 64)];
        mBoom = [[PBRenderable textureRenderableWithTexture:sTexture] retain];
        [mBoom setPosition:CGPointMake(0, 0)];

        IndexTexture *sIndexTexture = [[[IndexTexture alloc] initWithSize:CGSizeMake(100, 50)] autorelease];
        mIndexLabel = [[PBRenderable textureRenderableWithTexture:sIndexTexture] retain];
        [mIndexLabel setPosition:CGPointMake(-100, 0)];
        
        [[mView renderable] setSubrenderables:[NSArray arrayWithObjects:mBoom, mIndexLabel, nil]];
    }
    
    [[self view] addSubview:mView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    mView = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];
    
    [mView startDisplayLoop];
}


- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];
    
    [mView stopDisplayLoop];
}



#pragma mark -


- (void)pbViewUpdate:(PBView *)aView timeInterval:(CFTimeInterval)aTimeInterval displayLink:(CADisplayLink *)aDisplayLink
{
    if (mTextureIndex > 0)
    {
        PBTexture *sTexture = [mBoom texture];
        [sTexture selectTileAtIndex:mTextureIndex];
    }
    
    mTextureIndex++;
    
    if (mTextureIndex > 25)
    {
        mTextureIndex = -25;
    }
    
    [(IndexTexture *)[mIndexLabel texture] setString:[NSString stringWithFormat:@"INDEX = %d", mTextureIndex]];
}


@end
