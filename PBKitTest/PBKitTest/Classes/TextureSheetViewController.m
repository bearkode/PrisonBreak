/*
 *  TextureSheetViewController.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 2. 4..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "TextureSheetViewController.h"
#import <PBKit.h>
#import "IndexTexture.h"


@implementation TextureSheetViewController
{
    PBView       *mView;

    PBRenderable *mBoom;
    PBRenderable *mIndexLabel;
    
    PBRenderable *mVertex1;
    PBRenderable *mVertex2;
    PBRenderable *mVertex3;
    PBRenderable *mVertex4;
    
    PBRenderable *mRenderable;
    
    NSInteger     mTextureIndex;
}


- (id)initWithNibName:(NSString *)aNibNameOrNil bundle:(NSBundle *)aNibBundleOrNil
{
    self = [super initWithNibName:aNibNameOrNil bundle:aNibBundleOrNil];
    
    if (self)
    {
        mTextureIndex = 0;
        
        PBTileTexture *sTexture = [[PBTileTexture textureNamed:@"exp1.png"] load];
        [sTexture setSize:CGSizeMake(64, 64)];
        mBoom = [[PBRenderable textureRenderableWithTexture:sTexture] retain];
        
        IndexTexture *sIndexTexture = [[[IndexTexture alloc] initWithSize:CGSizeMake(100, 50)] autorelease];
        mIndexLabel = [[PBRenderable textureRenderableWithTexture:sIndexTexture] retain];
        
        sTexture = [[PBTexture textureNamed:@"poket0000.png"] load];
        mVertex1 = [[PBRenderable textureRenderableWithTexture:sTexture] retain];
        sTexture = [[PBTexture textureNamed:@"poket0001.png"] load];
        mVertex2 = [[PBRenderable textureRenderableWithTexture:sTexture] retain];
        sTexture = [[PBTexture textureNamed:@"poket0002.png"] load];
        mVertex3 = [[PBRenderable textureRenderableWithTexture:sTexture] retain];
        sTexture = [[PBTexture textureNamed:@"poket0003.png"] load];
        mVertex4 = [[PBRenderable textureRenderableWithTexture:sTexture] retain];

        PBTexture *sScaledTexture = [[[PBTexture alloc] initWithImageName:@"airship"] autorelease];
        [sScaledTexture load];
        mRenderable = [[PBRenderable textureRenderableWithTexture:sScaledTexture] retain];
    }
    
    return self;
}


- (void)dealloc
{
    [mBoom release];
    [mIndexLabel release];
    
    [mVertex1 release];
    [mVertex2 release];
    [mVertex3 release];
    [mVertex4 release];
    
    [mRenderable release];
    
    [super dealloc];
}


#pragma mark -


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mView = [[[PBView alloc] initWithFrame:[[self view] bounds]] autorelease];
    [mView setDisplayDelegate:self];
    [mView setDisplayFrameRate:kPBDisplayFrameRateHeigh];
    [mView setBackgroundColor:[PBColor blackColor]];
    [mView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    [[mView renderable] addSubrenderable:mBoom];
    [[mView renderable] addSubrenderable:mIndexLabel];
    
    [[mView renderable] addSubrenderable:mVertex1];
    [[mView renderable] addSubrenderable:mVertex2];
    [[mView renderable] addSubrenderable:mVertex3];
    [[mView renderable] addSubrenderable:mVertex4];
    
    [[mView renderable] addSubrenderable:mRenderable];
    
    [[self view] addSubview:mView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    mView = nil;
}


- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];

    CGRect  sBounds = [[self view] bounds];
    CGFloat sScale  = [[UIScreen mainScreen] scale];
    
    sBounds.origin.x    *= sScale;
    sBounds.origin.y    *= sScale;
    sBounds.size.width  *= sScale;
    sBounds.size.height *= sScale;
    
    [mVertex1 setPosition:CGPointMake(sBounds.origin.x, sBounds.origin.y)];
    [mVertex2 setPosition:CGPointMake(sBounds.origin.x + sBounds.size.width, sBounds.origin.y)];
    [mVertex3 setPosition:CGPointMake(sBounds.origin.x, sBounds.origin.y + sBounds.size.height)];
    [mVertex4 setPosition:CGPointMake(sBounds.origin.x + sBounds.size.width, sBounds.origin.y + sBounds.size.height)];
    
    [mBoom setPosition:CGPointMake(sBounds.size.width / 2, sBounds.size.height / 2)];
    [mIndexLabel setPosition:CGPointMake(sBounds.size.width / 2, sBounds.size.height / 2 - 80 * sScale)];
    
    [mRenderable setPosition:CGPointMake(sBounds.size.width / 2, 350 * sScale)];

    [[mView camera] setPosition:CGPointMake(sBounds.size.width / 2, sBounds.size.height / 2)];
    [[mView camera] setZoomScale:1.0];
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
    PBVertex3 sAngle;
    
    sAngle = [[mVertex1 transform] angle];
    sAngle.z += 3;
    [[mVertex1 transform] setAngle:sAngle];
    [[mVertex2 transform] setAngle:sAngle];
    [[mVertex3 transform] setAngle:sAngle];
    [[mVertex4 transform] setAngle:sAngle];
    
    
    if (mTextureIndex > 0)
    {
        PBTileTexture *sTexture = (PBTileTexture *)[mBoom texture];
        [sTexture selectTileAtIndex:mTextureIndex];
    }
    
    mTextureIndex++;
    
    if (mTextureIndex > 25)
    {
        mTextureIndex = -25;
    }
    
    [(IndexTexture *)[mIndexLabel texture] setString:[NSString stringWithFormat:@"INDEX = %d : %2.1f FPS", mTextureIndex, 1.0 / aTimeInterval]];
}


@end
