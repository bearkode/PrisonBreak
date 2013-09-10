/*
 *  PBNode.m
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 4..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBNode.h"
#import "PBRenderer.h"
#import "PBScene.h"
#import "PBColor.h"
#import "PBTransform.h"
#import "PBException.h"
#import "PBEffectNode.h"


@implementation PBNode
{
    PBNode         *mSuperNode;
    PBTransform    *mTransform;
    PBMesh         *mMesh;
    
    NSString       *mName;
    PBColor        *mSelectionColor;
    BOOL            mSelectable;
    BOOL            mHidden;

    NSMutableArray *mSubNodes;
}


@synthesize name   = mName;
@synthesize hidden = mHidden;


#pragma mark -


+ (Class)meshClass
{
    return [PBMesh class];
}


#pragma mark -
#pragma mark Privates


- (PBMesh *)mesh
{
    return mMesh;
}


//- (void)setMesh:(PBMesh *)aMesh
//{
//    [mMesh autorelease];
//    mMesh = [aMesh retain];
//}
//
//
#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mTransform = [[PBTransform alloc] init];
        mMesh      = [[[[self class] meshClass] alloc] init];
        mSubNodes  = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mMesh release];
    [mSelectionColor release];
    [mName release];
    [mTransform release];
    [mSubNodes release];

    [super dealloc];
}


#pragma mark - Private


- (void)pushMesh
{
    [mMesh setTransform:mTransform];
    [mMesh setColor:([mTransform color]) ? [mTransform color] : [mSuperNode color]];
    
    if (!mHidden && ![self isKindOfClass:[PBEffectNode class]])
    {
        [mMesh pushMesh];
    }
}


- (void)pushSelectionMesh
{
    [mMesh setTransform:mTransform];
    [mMesh setColor:mSelectionColor];
    
    if (!mHidden && ![self isKindOfClass:[PBEffectNode class]])
    {
        [mMesh pushMesh];
    }
}


#pragma mark -


- (void)setPoint:(CGPoint)aPoint
{
    [mMesh setPoint:aPoint];
    [mTransform setTranslate:PBVertex3Make(aPoint.x, aPoint.y, 0)];
}


- (CGPoint)point
{
    return [mMesh point];
}


- (void)setZPoint:(GLfloat)aZPoint
{
    [mMesh setZPoint:aZPoint];
    [mMesh updateMeshData];
}


- (GLfloat)zPoint
{
    return [mMesh zPoint];
}


- (void)setProjectionPackEnabled:(BOOL)aEnable
{
    [mMesh setProjectionPackEnabled:aEnable];
}


#pragma mark -


- (void)setSuperNode:(PBNode *)aNode
{
    mSuperNode = aNode;
}


- (PBNode *)superNode
{
    return mSuperNode;
}


- (NSArray *)subNodes
{
    return mSubNodes;
}


- (void)removeAllNodes
{
    [mSubNodes makeObjectsPerformSelector:@selector(setSuperNode:) withObject:nil];
    [mSubNodes removeAllObjects];
}


- (void)setSubNodes:(NSArray *)aSubNodes
{
    [mSubNodes removeAllObjects];
    [aSubNodes makeObjectsPerformSelector:@selector(setSuperNode:) withObject:self];
    [mSubNodes addObjectsFromArray:aSubNodes];
}


- (void)addSubNode:(PBNode *)aNode
{
    NSAssert(aNode, @"aNode is nil");
    
    [aNode setSuperNode:self];
    [mSubNodes addObject:aNode];
}


- (void)addSubNodes:(NSArray *)aNodes
{
    [aNodes makeObjectsPerformSelector:@selector(setSuperNode:) withObject:self];
    [mSubNodes addObjectsFromArray:aNodes];
}


- (void)removeSubNode:(PBNode *)aNode
{
    NSAssert(aNode, @"");

    [aNode setSuperNode:nil];
    [mSubNodes removeObject:aNode];
}


- (void)removeSubNodes:(NSArray *)aNodes
{
    [aNodes makeObjectsPerformSelector:@selector(setSuperNode:) withObject:nil];
    [mSubNodes removeObjectsInArray:aNodes];
}


- (void)removeFromSuperNode
{
    [mSuperNode removeSubNode:self];
    mSuperNode = nil;
}


- (PBScene *)scene
{
    if ([mSuperNode isKindOfClass:[PBScene class]])
    {
        return (PBScene *)mSuperNode;
    }
    
    return [mSuperNode scene];
}


#pragma mark -


- (void)push
{
    [self pushMesh];
    PBMatrix sProjection = [mMesh projection];

    for (PBNode *sNode in mSubNodes)
    {
        if ([mMesh projectionPackEnabled])
        {
            [[sNode mesh] setProjectionPackEnabled:[mMesh projectionPackEnabled]];
        } 
        [[sNode mesh] setSceneProjection:[mMesh SceneProjection]];
        [[sNode mesh] setProjection:sProjection];
        [sNode push];
    }
}


- (void)pushSelectionWithRenderer:(PBRenderer *)aRenderer
{
    if ([self isSelectable])
    {
        [aRenderer addNodeForSelection:self];
        [self pushSelectionMesh];
    }
    
    PBMatrix sProjection = [mMesh projection];
    
    for (PBNode *sNode in mSubNodes)
    {
        if ([mMesh projectionPackEnabled])
        {
            [[sNode mesh] setProjectionPackEnabled:[mMesh projectionPackEnabled]];
        }
        [[sNode mesh] setSceneProjection:[mMesh SceneProjection]];
        [[sNode mesh] setProjection:sProjection];
        [sNode pushSelectionWithRenderer:aRenderer];
    }
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


#pragma mark -
#pragma mark Transform


- (void)setScale:(CGFloat)aScale
{
    [mTransform setScale:aScale];
}


- (CGFloat)scale
{
    return [mTransform scale];
}


- (void)setAngle:(PBVertex3)aAngle
{
    [mTransform setAngle:aAngle];
}


- (PBVertex3)angle
{
    return [mTransform angle];
}


- (void)setColor:(PBColor *)aColor
{
    [mTransform setColor:aColor];
}


- (PBColor *)color
{
    return [mTransform color];
}


- (void)setAlpha:(CGFloat)aAlpha
{
    [mTransform setAlpha:aAlpha];
}


- (CGFloat)alpha
{
    return [mTransform alpha];
}


- (void)setCoordinateMode:(PBCoordinateMode)aMode
{
    [[self mesh] setCoordinateMode:(PBMeshCoordinateMode)aMode];
}


- (PBCoordinateMode)coordinateMode
{
    return (PBCoordinateMode)[[self mesh] coordinateMode];
}


@end
