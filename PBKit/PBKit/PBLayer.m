/*
 *  PBLayer.m
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 4..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBKit.h"
#import "PBException.h"


@implementation PBLayer
{
    PBTransform    *mTransform;
    PBBlendMode     mBlendMode;
    
    PBLayer        *mSuperlayer;
    NSMutableArray *mSublayers;

    PBMesh         *mMesh;
    PBTexture      *mTexture;

    NSString       *mName;
    CGPoint         mPosition;
    PBColor        *mSelectionColor;
    BOOL            mSelectable;
    BOOL            mHidden;
}


@synthesize transform  = mTransform;
@synthesize mesh       = mMesh;
@synthesize blendMode  = mBlendMode;
@synthesize name       = mName;
@synthesize selectable = mSelectable;
@synthesize hidden     = mHidden;


#pragma mark -


+ (Class)meshClass
{
    return [PBMesh class];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mBlendMode.sfactor = GL_ONE;
        mBlendMode.dfactor = GL_ONE_MINUS_SRC_ALPHA;
        mSublayers         = [[NSMutableArray alloc] init];
        mPosition          = CGPointMake(0, 0);
        mTransform         = [[PBTransform alloc] init];
        mMesh              = [[[[self class] meshClass] alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mTexture removeObserver:self forKeyPath:@"size"];
    [mTexture removeObserver:self forKeyPath:kPBTextureLoadedKey];
    
    [mMesh release];
    [mSelectionColor release];
    [mName release];
    [mTransform release];
    [mSublayers release];
    [mTexture release];
    
    [super dealloc];
}


#pragma mark - Private


- (void)renderMesh
{
    [mMesh applyProgram:mTransform];
    [mMesh applyTransform:mTransform];
    [mMesh applyColor:([[mSuperlayer transform] color]) ? [[mSuperlayer transform] color] : [mTransform color]];

    (!mHidden) ? [mMesh draw] : nil;
}


- (void)renderSelectionMesh
{
    PBProgram *sBeforeProgram = [PBProgramManager currentProgram];
    [self setProgram:[[PBProgramManager sharedManager] selectionProgram]];

    [mMesh applyTransform:mTransform];
    [mMesh applyColor:mSelectionColor];
    
    (!mHidden) ? [mMesh draw] : nil;

    [self setProgram:sBeforeProgram];
}


#pragma mark -


- (void)setTexture:(PBTexture *)aTexture
{
    [mTexture removeObserver:self forKeyPath:@"size"];
    [mTexture removeObserver:self forKeyPath:kPBTextureLoadedKey];
    [mTexture autorelease];
    
    mTexture = [aTexture retain];
    [mTexture addObserver:self forKeyPath:@"size" options:NSKeyValueObservingOptionNew context:NULL];
    [mTexture addObserver:self forKeyPath:kPBTextureLoadedKey options:NSKeyValueObservingOptionNew context:NULL];
    
    if ([aTexture isLoaded])
    {
        [PBContext performBlockOnMainThread:^{
            [mMesh setTexture:aTexture];
        }];
    }
}


- (PBTexture *)texture
{
    return mTexture;
}


#pragma mark -


- (BOOL)hasProgram
{
    return ([mMesh program]) ? YES : NO;
}


- (void)setProgram:(PBProgram *)aProgram
{
    [mMesh setProgram:aProgram];
}


- (void)setPosition:(CGPoint)aPosition textureSize:(CGSize)aTextureSize
{
    mPosition = aPosition;
    [[self transform] setTranslate:PBVertex3Make(mPosition.x, mPosition.y, 0)];

}


- (void)setPosition:(CGPoint)aPosition
{
    [self setPosition:aPosition textureSize:[mTexture size]];
}


- (CGPoint)position
{
    return mPosition;
}


#pragma mark -


- (void)setSuperlayer:(PBLayer *)aLayer
{
    mSuperlayer = aLayer;
}


- (PBLayer *)superlayer
{
    return mSuperlayer;
}


- (NSArray *)sublayers
{
    return [[mSublayers copy] autorelease];
}


- (void)setSublayers:(NSArray *)aSublayers
{
    NSArray *sOldSublayers = [mSublayers copy];

    [mSublayers makeObjectsPerformSelector:@selector(setSuperlayer:) withObject:nil];
    [mSublayers setArray:aSublayers];
    [mSublayers makeObjectsPerformSelector:@selector(setSuperlayer:) withObject:self];

    [sOldSublayers release];
}


- (void)addSublayer:(PBLayer *)aLayer
{
    NSAssert(aLayer, @"aLayer is nil");
    
    [aLayer setSuperlayer:self];
    [mSublayers addObject:aLayer];
}


- (void)removeSublayer:(PBLayer *)aLayer
{
    NSAssert(aLayer, @"");
    
    [mSublayers removeObjectIdenticalTo:aLayer];
}


- (void)removeFromSuperlayer
{
    [mSuperlayer removeSublayer:self];
    mSuperlayer = nil;
}


#pragma mark -


- (void)render
{
    if ([self hasProgram])
    {
        if (mBlendMode.sfactor != GL_ONE || mBlendMode.dfactor != GL_ONE_MINUS_SRC_ALPHA)
        {
            glBlendFunc(mBlendMode.sfactor, mBlendMode.dfactor);
        }

        [self renderMesh];
    }

    for (PBLayer *sLayer in mSublayers)
    {
        [[sLayer mesh] setProjection:[[self mesh] projection]];
        [sLayer render];
    }
}


- (void)renderSelectionWithRenderer:(PBRenderer *)aRenderer
{
    [aRenderer addLayerForSelection:self];

    [self renderSelectionMesh];
    
    for (PBLayer *sLayer in mSublayers)
    {
        [[sLayer mesh] setProjection:[[self mesh] projection]];
        [sLayer renderSelectionWithRenderer:aRenderer];
    }
}


#pragma mark -


- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)aObject change:(NSDictionary *)aChange context:(void *)aContext
{
    if ([aKeyPath isEqualToString:@"size"] && aObject == mTexture)
    {
        [PBContext performBlockOnMainThread:^{
            [mMesh updateMeshData];
        }];
    }
    else if ([aKeyPath isEqualToString:kPBTextureLoadedKey] && aObject == mTexture)
    {
        [PBContext performBlockOnMainThread:^{
            [mMesh setTexture:mTexture];
        }];
    }
}


#pragma mark -


- (void)setSelectionColorWithRed:(CGFloat)aRed green:(CGFloat)aGreen blue:(CGFloat)aBlue
{
    [mSelectionColor autorelease];
    mSelectionColor = [[PBColor colorWithRed:aRed green:aGreen blue:aBlue alpha:1.0f] retain];
}


@end


