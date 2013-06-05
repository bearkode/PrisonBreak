/*
 *  PBDrawingSprite.m
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 13..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBDrawingSprite.h"
#import "PBDynamicTexture.h"
#import "PBProgramManager.h"
#import "PBProgram.h"
#import "PBContext.h"


@implementation PBDrawingSprite
{
    id   mDelegate;
    BOOL mRefresh;
}


@synthesize delegate = mDelegate;


#pragma mark -


- (id)initWithSize:(CGSize)aSize
{
    self = [super init];
    
    if (self)
    {
        PBDynamicTexture *sTexture = [[PBDynamicTexture alloc] initWithSize:aSize scale:[[UIScreen mainScreen] scale]];
        [self setTexture:sTexture];
        [sTexture setDrawDelegate:self];
        [sTexture release];
        
        [self refresh];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)setSize:(CGSize)aSize
{
    [(PBDynamicTexture *)[self texture] setSize:aSize];
}


- (void)refresh
{
    mRefresh = YES;
}


- (void)push
{
    if (mRefresh)
    {
        [(PBDynamicTexture *)[self texture] update];
        mRefresh = NO;
    }
    
    [super push];
}


- (void)pushSelectionWithRenderer:(PBRenderer *)aRenderer
{
    if (mRefresh)
    {
        [(PBDynamicTexture *)[self texture] update];
        mRefresh = NO;
    }
    
    [super pushSelectionWithRenderer:aRenderer];
}


#pragma mark -


- (void)texture:(PBDynamicTexture *)aTexture drawInRect:(CGRect)aRect context:(CGContextRef)aContext
{
    NSAssert(aContext, @"");
    
    if (mDelegate)
    {
        [mDelegate sprite:self drawInRect:aRect context:aContext];
    }
}


@end
