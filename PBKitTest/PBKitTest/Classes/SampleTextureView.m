/*
 *  SampleTextureView.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 1. 21..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "SampleTextureView.h"
#import <PBKit.h>


@implementation SampleTextureView
{

}


@synthesize scale = mScale;
@synthesize angle = mAngle;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        PBProgram *sProgram = [[PBProgramManager sharedManager] textureProgram];
        [self setBackgroundColor:[PBColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];

        PBTexture *sTexture = [[[PBTexture alloc] initWithImageName:@"brown.png"] autorelease];
        [sTexture load];
        mRenderable1 = [[PBRenderable alloc] initWithTexture:sTexture];
        [mRenderable1 setProgram:sProgram];
        [mRenderable1 setName:@"brown"];

        PBTexture *sTexture2 = [[[PBTexture alloc] initWithImageName:@"coin.png"] autorelease];
        [sTexture2 load];
        mRenderable2 = [[PBRenderable alloc] initWithTexture:sTexture2];
        [mRenderable2 setProgram:sProgram];
        [mRenderable2 setName:@"coin"];
        
        PBTexture *sTexture3 = [[[PBTexture alloc] initWithImageName:@"balloon.png"] autorelease];
        [sTexture3 load];
        mRenderable3 = [[PBRenderable alloc] initWithTexture:sTexture3];
        [mRenderable3 setProgram:sProgram];
        [mRenderable3 setName:@"balloon"];
        
        [self registGestureEvent];
        
        [mRenderable1  setPosition:CGPointMake(-70, 0)];
        [mRenderable2 setPosition:CGPointMake(30, 0)];
        [mRenderable3 setPosition:CGPointMake(80, -60)];

    }
    return self;
}


- (void)dealloc
{
    [mRenderable1 release];
    [mRenderable2 release];
    [mRenderable3 release];
    
    [super dealloc];
}


#pragma mark -


- (void)pbViewUpdate:(PBView *)aView timeInterval:(CFTimeInterval)aTimeInterval displayLink:(CADisplayLink *)aDisplayLink
{
    [[mRenderable1 transform] setScale:mScale];
    [[mRenderable1 transform] setAngle:PBVertex3Make(0, 0, mAngle)];
    
    
//    [[mTexture2 transform] setScale:mScale];
    [[mRenderable2 transform] setAngle:PBVertex3Make(0, 0, mAngle)];
    
    [[mRenderable3 transform] setScale:mScale];
    [[mRenderable3 transform] setAngle:PBVertex3Make(0, 0, mAngle)];

    [mRenderable1 setSelectable:YES];
    [mRenderable2 setSelectable:YES];
    
    // subrenderable test
    [mRenderable1 setSubrenderables:[NSArray arrayWithObjects:mRenderable2, nil]];
    [[self renderable] setSubrenderables:[NSArray arrayWithObjects:mRenderable1, mRenderable3,  nil]];
    
    
    // convert position test
//    [[aView renderable] setSubrenderables:[NSArray arrayWithObjects:mRenderable2,  nil]];
}


- (void)pbView:(PBView *)aView didTapPoint:(CGPoint)aPoint
{
    // select test
    [self beginSelectionMode];
    PBRenderable *sSelectedRenderable = [self selectedRenderableAtPoint:aPoint];
    if ([sSelectedRenderable name])
    {
         NSLog(@"selected = %@", [sSelectedRenderable name]);   
    }
    [self endSelectionMode];
}


@end
