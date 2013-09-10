/*
 *  PBDynamicNode.m
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 29..
 *  Copyright (c) 2013 NHN. All rights reserved.
 *
 */

#import "PBDynamicNode.h"
#import "PBDynamicTexture.h"
#import "PBNodePrivate.h"


@implementation PBDynamicNode


+ (Class)meshClass
{
    return [PBMesh class];
}


#pragma mark -


- (id)initWithImageNamed:(NSString *)aName
{
    NSAssert(NO, @"");
    
    return nil;
}


- (id)initWithTexture:(PBTexture *)aTexture
{
    NSAssert([aTexture isKindOfClass:[PBDynamicTexture class]], @"");
    
    self = [super init];
    
    if (self)
    {
        [self setTexture:aTexture];
    }
    
    return self;
}


- (id)initWithSize:(CGSize)aSize
{
    self = [super init];
    
    if (self)
    {
        PBDynamicTexture *sTexture = [[[PBDynamicTexture alloc] initWithSize:aSize scale:[[UIScreen mainScreen] scale]] autorelease];
        [self setTexture:sTexture];
        [sTexture setDrawDelegate:self];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)setTextureSize:(CGSize)aSize
{
    PBDynamicTexture *sTexture = (PBDynamicTexture *)[self texture];
    
    [sTexture setSize:aSize];
    [sTexture update];
    
    [[self mesh] setVertexSize:aSize];
    [[self mesh] updateMeshData];
}


- (void)updateTexture
{
    [(PBDynamicTexture *)[self texture] update];
}


- (void)texture:(PBDynamicTexture *)aTexture drawInRect:(CGRect)aRect context:(CGContextRef)aContext
{
    NSAssert(aContext, @"");
    
    [self drawInRect:aRect context:(CGContextRef)aContext];
}


- (void)drawInRect:(CGRect)aRect context:(CGContextRef)aContext
{
    
}


@end
