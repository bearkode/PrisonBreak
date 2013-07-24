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
    CGPoint         mPoint;
    PBColor        *mSelectionColor;
    BOOL            mSelectable;
    BOOL            mHidden;

    NSMutableArray *mSubnodes;
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


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mPoint     = CGPointMake(0, 0);
        mTransform = [[PBTransform alloc] init];
        mMesh      = [[[[self class] meshClass] alloc] init];
        mSubnodes  = [[NSMutableArray alloc] init];
    }
    
    return self;
}


- (void)dealloc
{
    [mMesh release];
    [mSelectionColor release];
    [mName release];
    [mTransform release];
    [mSubnodes release];

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
    mPoint = aPoint;
    [mTransform setTranslate:PBVertex3Make(mPoint.x, mPoint.y, 0)];
}


- (CGPoint)point
{
    return mPoint;
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
    return mSubnodes;
}


- (void)removeAllNodes
{
    [mSubnodes removeAllObjects];
}


- (void)setSubNodes:(NSArray *)aSubNodes
{
    [mSubnodes removeAllObjects];
    [mSubnodes addObjectsFromArray:aSubNodes];
}


- (void)addSubNode:(PBNode *)aNode
{
    NSAssert(aNode, @"aNode is nil");
    
    [mSubnodes addObject:aNode];
}


- (void)addSubNodes:(NSArray *)aNodes
{
    [mSubnodes addObjectsFromArray:aNodes];
}


- (void)removeSubNode:(PBNode *)aNode
{
    NSAssert(aNode, @"");

    [mSubnodes removeObject:aNode];
}


- (void)removeSubNodes:(NSArray *)aNodes
{
    [mSubnodes removeObjectsInArray:aNodes];
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

    for (PBNode *sNode in mSubnodes)
    {
        [[sNode mesh] setAnchorPoint:CGPointMake([mMesh anchorPoint].x + mPoint.x, [mMesh anchorPoint].y + mPoint.y)];
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
    
    PBMatrix sProjection = [[self mesh] projection];
    
    for (PBNode *sNode in mSubnodes)
    {
        [[sNode mesh] setAnchorPoint:CGPointMake([mMesh anchorPoint].x + mPoint.x, [mMesh anchorPoint].y + mPoint.y)];
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


@end
