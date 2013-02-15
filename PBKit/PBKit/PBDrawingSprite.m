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


@implementation PBDrawingSprite
{
    id mDelegate;
}


@synthesize delegate = mDelegate;


#pragma mark -


- (id)initWithSize:(CGSize)aSize
{
    self = [super init];
    
    if (self)
    {
        [self setProgram:[[PBProgramManager sharedManager] textureProgram]];
        
        PBDynamicTexture *sTexture = [[PBDynamicTexture alloc] initWithSize:aSize scale:[[UIScreen mainScreen] scale]];
        [sTexture setDelegate:self];
        
        [self setTexture:sTexture];
        
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
    [(PBDynamicTexture *)[self texture] update];
}


#pragma mark -


- (void)drawInRect:(CGRect)aRect context:(CGContextRef)aContext
{
    if (mDelegate)
    {
        [mDelegate sprite:self drawInRect:aRect context:aContext];
    }
}


@end
