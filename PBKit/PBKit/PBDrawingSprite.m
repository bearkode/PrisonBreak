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
#import "PBShaderManager.h"
#import "PBShaderProgram.h"


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
        GLuint sProgram = [[[PBShaderManager sharedManager] textureShader] program];
        [self setProgram:sProgram];
        
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


- (CGFloat)scale
{
    return [[self texture] scale];
}


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
