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
    
    PBLayer        *mSuperlayer;
#if (USE_NSARRAY)
    NSMutableArray *mSublayers;
#endif
    PBLayer        *mHeadLayer;
    
    PBMesh         *mMesh;
    PBTexture      *mTexture;
    
    NSString       *mName;
    CGPoint         mPoint;
    PBColor        *mSelectionColor;
    BOOL            mSelectable;
    BOOL            mHidden;
    
#if (!USE_NSARRAY)
    PBLayer        *mNextLayer;
    PBLayer        *mPrevLayer; /*  assign  */
    PBLayer        *mLastLayer; /*  assign  */
#endif
}


@synthesize transform  = mTransform;
@synthesize mesh       = mMesh;
@synthesize name       = mName;
@synthesize hidden     = mHidden;


#pragma mark -


+ (Class)meshClass
{
    return [PBMesh class];
}


#if (!USE_NSARRAY)
- (void)setNextLayer:(PBLayer *)aLayer
{
    [mNextLayer autorelease];
    mNextLayer = [aLayer retain];
}


- (PBLayer *)nextLayer
{
    return mNextLayer;
}


- (void)setPrevLayer:(PBLayer *)aLayer
{
    mPrevLayer = aLayer;
}


- (PBLayer *)prevLayer
{
    return mPrevLayer;
}
#endif


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
#if (USE_NSARRAY)
        mSublayers         = [[NSMutableArray alloc] init];
#endif
        mPoint             = CGPointMake(0, 0);
        mTransform         = [[PBTransform alloc] init];
        mMesh              = [[[[self class] meshClass] alloc] init];
        
        mPushSelector      = @selector(push);
        mPushFunc          = (PBLayerPushFuncPtr)[self methodForSelector:mPushSelector];
    }
    
    return self;
}


- (void)dealloc
{
    [mTexture setDelegate:nil];
    
    [mMesh release];
    [mSelectionColor release];
    [mName release];
    [mTransform release];
#if (USE_NSARRAY)
    [mSublayers release];
#else
    [mHeadLayer release];
    [mNextLayer release];
#endif
    [mTexture release];
    
    [super dealloc];
}


#pragma mark - Private


- (void)pushMesh
{
    [mMesh setProgramForTransform:mTransform];
    [mMesh setTransform:mTransform];
    [mMesh setColor:([mTransform color]) ? [mTransform color] : [[mSuperlayer transform] color]];
    
    (!mHidden) ? [mMesh pushMesh] : nil;
}


- (void)pushSelectionMesh
{
    [mMesh setTransform:mTransform];
    [mMesh setColor:mSelectionColor];
    
    (!mHidden) ? [mMesh pushMesh] : nil;
}


#pragma mark -


- (void)setTexture:(PBTexture *)aTexture
{
    [mTexture setDelegate:nil];
    [mTexture autorelease];
    
    mTexture = [aTexture retain];
    [mTexture setDelegate:self];
    
    if ([aTexture isLoaded])
    {
        [mMesh setTexture:aTexture];
    }
}


- (PBTexture *)texture
{
    return mTexture;
}


- (void)setMeshRenderOption:(PBMeshRenderOption)aRenderOption
{
    [mMesh setMeshRenderOption:aRenderOption];
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


- (void)setPoint:(CGPoint)aPoint
{
    mPoint = aPoint;
    [[self transform] setTranslate:PBVertex3Make(mPoint.x, mPoint.y, 0)];
}


- (CGPoint)point
{
    return mPoint;
}


- (void)setPointZ:(GLfloat)aPointZ
{
    [mMesh setPointZ:aPointZ];
    [mMesh updateMeshData];
}


- (GLfloat)zPoint
{
    return [mMesh zPoint];
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
#if (USE_NSARRAY)
    return [[mSublayers copy] autorelease];
#else
    NSMutableArray *sResult = nil;
    PBLayer        *sLayer  = mHeadLayer;
    
    if (sLayer)
    {
        sResult = [NSMutableArray array];
        
        do
        {
            [sResult addObject:sLayer];
        } while ((sLayer = [sLayer nextLayer]));
    }
    
    return sResult;
#endif
}


#if (!USE_NSARRAY)
- (void)removeAllLayers
{
    PBLayer *sLayer = mHeadLayer;

    do {
        [sLayer setSuperlayer:nil];
    } while ((sLayer = [sLayer nextLayer]));

    [mHeadLayer autorelease];
    mHeadLayer = nil;
}
#endif


- (void)setSublayers:(NSArray *)aSublayers
{
#if (USE_NSARRAY)
    NSArray *sOldSublayers = [mSublayers copy];
    
    [mSublayers makeObjectsPerformSelector:@selector(setSuperlayer:) withObject:nil];
    [mSublayers setArray:aSublayers];
    [mSublayers makeObjectsPerformSelector:@selector(setSuperlayer:) withObject:self];
    
    [sOldSublayers release];
#else
    [self removeAllLayers];
    
    PBLayer *sPrevLayer = nil;
    for (PBLayer *sLayer in aSublayers)
    {
        if (!mHeadLayer)
        {
            mHeadLayer = [sLayer retain];
            [mHeadLayer setPrevLayer:nil];
        }
        else
        {
            [sPrevLayer setNextLayer:sLayer];
            [sLayer setPrevLayer:sPrevLayer];
        }
        
        [sLayer setSuperlayer:self];
        
        sPrevLayer = sLayer;
    }
    
    mLastLayer = [aSublayers lastObject];
    [mLastLayer setNextLayer:nil];
#endif
}


- (void)addSublayer:(PBLayer *)aLayer
{
    NSAssert(aLayer, @"aLayer is nil");
    
#if (USE_NSARRAY)
    [aLayer setSuperlayer:self];
    [mSublayers addObject:aLayer];
#else
    [aLayer setSuperlayer:self];
    
    if (!mHeadLayer)
    {
        mHeadLayer = [aLayer retain];
    }
    else
    {
        [mLastLayer setNextLayer:aLayer];
        [aLayer setPrevLayer:mLastLayer];
    }
    
    mLastLayer = aLayer;
#endif
}


- (void)addSublayers:(NSArray *)aLayers
{
#if (USE_NSARRAY)
    [mSublayers addObjectsFromArray:aLayers];
#else
    for (PBLayer *sLayer in aLayers)
    {
        [self addSublayer:sLayer];
    }
#endif
}


- (void)removeSublayer:(PBLayer *)aLayer
{
    NSAssert(aLayer, @"");
    
#if (USE_NSARRAY)
    [mSublayers removeObjectIdenticalTo:aLayer];
#else
    PBLayer *sPrevLayer = [aLayer prevLayer];
    PBLayer *sNextLayer = [aLayer nextLayer];
    
    [sPrevLayer setNextLayer:sNextLayer];
    [sNextLayer setPrevLayer:sPrevLayer];
    
    [aLayer setSuperlayer:nil];
    [aLayer setPrevLayer:nil];
    [aLayer setNextLayer:nil];
    
    if (aLayer == mLastLayer)
    {
        mLastLayer = sPrevLayer;
    }
    
    if (aLayer == mHeadLayer)
    {
        [mHeadLayer autorelease];
        mHeadLayer = [sNextLayer retain];
    }
#endif
}


- (void)removeSublayers:(NSArray *)aLayers
{
#if (USE_NSARRAY)
    [mSublayers removeObjectsInArray:aLayers];
#else
    for (PBLayer *sLayer in aLayers)
    {
        [self removeSublayer:sLayer];
    }
#endif
}


- (void)removeFromSuperlayer
{
    [mSuperlayer removeSublayer:self];
    mSuperlayer = nil;
}


- (PBRootLayer *)rootLayer
{
    if ([mSuperlayer isKindOfClass:[PBRootLayer class]])
    {
        return (PBRootLayer *)mSuperlayer;
    }
    
    return [mSuperlayer rootLayer];
}


#pragma mark -


#if (USE_NSARRAY)
- (void)sortSublayersUsingSelector:(SEL)aSelector
{
    [mSublayers sortUsingSelector:aSelector];
}
#endif


#pragma mark -


- (void)push
{
    if ([mMesh program])
    {
        [self pushMesh];
    }

#if (USE_NSARRAY)
    if ([mSublayers count])
    {
        PBMatrix sProjection = [mMesh projection];
        for (PBLayer *sLayer in mSublayers)
        {
            [[sLayer mesh] setProjection:sProjection];  // TODO : 항상 projection을 set할 필요가 있나?
            [sLayer push];
        }
    }
#else
    if (mHeadLayer)
    {
        PBLayer *sLayer      = mHeadLayer;
        PBMatrix sProjection = [mMesh projection];
        
        do
        {
            [[sLayer mesh] setProjection:sProjection];
            sLayer->mPushFunc(sLayer, sLayer->mPushSelector);
        } while ((sLayer = sLayer->mNextLayer));
    }
#endif
}


- (void)pushSelectionWithRenderer:(PBRenderer *)aRenderer
{
    [aRenderer addLayerForSelection:self];
    
    [self pushSelectionMesh];

#if (USE_NSARRAY)
    for (PBLayer *sLayer in mSublayers)
    {
        [[sLayer mesh] setProjection:[[self mesh] projection]];
        [sLayer pushSelectionWithRenderer:aRenderer];
    }
#else
    if (mHeadLayer)
    {
        PBLayer *sLayer      = mHeadLayer;
        PBMatrix sProjection = [[self mesh] projection];
        
        do
        {
            [[sLayer mesh] setProjection:sProjection];
            [sLayer pushSelectionWithRenderer:aRenderer];
        } while ((sLayer = sLayer->mNextLayer));
    }
#endif
}


#pragma mark -


- (void)textureDidResize:(PBTexture *)aTexture
{
    [PBContext performBlockOnMainThread:^{
        [mMesh updateMeshData];
    }];
}


- (void)textureDidLoad:(PBTexture *)aTexture
{
    [PBContext performBlockOnMainThread:^{
        [mMesh setTexture:mTexture];
    }];
}


#pragma mark -


- (void)setSelectable:(BOOL)aSelectable
{
    mSelectable = aSelectable;
}


- (BOOL)isSelectable
{
    return mSelectable;
}


- (void)setSelectionColorWithRed:(CGFloat)aRed green:(CGFloat)aGreen blue:(CGFloat)aBlue
{
    [mSelectionColor autorelease];
    mSelectionColor = [[PBColor colorWithRed:aRed green:aGreen blue:aBlue alpha:1.0f] retain];
}


@end


