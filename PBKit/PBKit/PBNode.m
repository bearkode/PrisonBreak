/*
 *  PBNode.m
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 4..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "PBKit.h"
#import "PBException.h"


@implementation PBNode
{
    PBTransform *mTransform;
    
    PBNode      *mSuperNode;
    PBNode      *mHeadNode;
    
    PBMesh      *mMesh;
    
    NSString    *mName;
    CGPoint      mPoint;
    PBColor     *mSelectionColor;
    BOOL         mSelectable;
    BOOL         mHidden;
    
    PBNode      *mNextNode;
    PBNode      *mPrevNode; /*  assign  */
    PBNode      *mLastNode; /*  assign  */
}


@synthesize mesh       = mMesh;
@synthesize name       = mName;
@synthesize hidden     = mHidden;


#pragma mark -


+ (Class)meshClass
{
    return [PBMesh class];
}


- (void)setNextNode:(PBNode *)aNode
{
    [mNextNode autorelease];
    mNextNode = [aNode retain];
}


- (PBNode *)nextNode
{
    return mNextNode;
}


- (void)setPrevNode:(PBNode *)aNode
{
    mPrevNode = aNode;
}


- (PBNode *)prevNode
{
    return mPrevNode;
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        mPoint        = CGPointMake(0, 0);
        mTransform    = [[PBTransform alloc] init];
        mMesh         = [[[[self class] meshClass] alloc] init];
        mPushSelector = @selector(push);
        mPushFunc     = (PBNodePushFuncPtr)[self methodForSelector:mPushSelector];
    }
    
    return self;
}


- (void)dealloc
{
    [mMesh release];
    [mSelectionColor release];
    [mName release];
    [mTransform release];
    [mHeadNode release];
    [mNextNode release];

    [super dealloc];
}


#pragma mark - Private


- (void)pushMesh
{
    [mMesh setProgramForTransform:mTransform];
    [mMesh setTransform:mTransform];
    [mMesh setColor:([mTransform color]) ? [mTransform color] : [mSuperNode color]];
    
    (!mHidden) ? [mMesh pushMesh] : nil;
}


- (void)pushSelectionMesh
{
    [mMesh setTransform:mTransform];
    [mMesh setColor:mSelectionColor];
    
    (!mHidden) ? [mMesh pushMesh] : nil;
}


#pragma mark -


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
    NSMutableArray *sResult = nil;
    PBNode        *sNode    = mHeadNode;
    
    if (sNode)
    {
        sResult = [NSMutableArray array];
        
        do
        {
            [sResult addObject:sNode];
        } while ((sNode = [sNode nextNode]));
    }
    
    return sResult;
}


- (void)removeAllNodes
{
    PBNode *sNode = mHeadNode;

    do {
        [sNode setSuperNode:nil];
    } while ((sNode = [sNode nextNode]));

    [mHeadNode autorelease];
    mHeadNode = nil;
}


- (void)setSubNodes:(NSArray *)aSubNodes
{
    [self removeAllNodes];
    
    PBNode *sPrevNode = nil;
    for (PBNode *sNode in aSubNodes)
    {
        if (!mHeadNode)
        {
            mHeadNode = [sNode retain];
            [mHeadNode setPrevNode:nil];
        }
        else
        {
            [sPrevNode setNextNode:sNode];
            [sNode setPrevNode:sPrevNode];
        }
        
        [sNode setSuperNode:self];
        
        sPrevNode = sNode;
    }
    
    mLastNode = [aSubNodes lastObject];
    [mLastNode setNextNode:nil];
}


- (void)addSubNode:(PBNode *)aNode
{
    NSAssert(aNode, @"aNode is nil");
    
    [aNode setSuperNode:self];
    
    if (!mHeadNode)
    {
        mHeadNode = [aNode retain];
    }
    else
    {
        [mLastNode setNextNode:aNode];
        [aNode setPrevNode:mLastNode];
    }
    
    mLastNode = aNode;
}


- (void)addSubNodes:(NSArray *)aNodes
{
    for (PBNode *sNode in aNodes)
    {
        [self addSubNode:sNode];
    }
}


- (void)removeSubNode:(PBNode *)aNode
{
    NSAssert(aNode, @"");
    
    PBNode *sPrevNode = [aNode prevNode];
    PBNode *sNextNode = [aNode nextNode];
    
    [sPrevNode setNextNode:sNextNode];
    [sNextNode setPrevNode:sPrevNode];
    
    [aNode setSuperNode:nil];
    [aNode setPrevNode:nil];
    [aNode setNextNode:nil];
    
    if (aNode == mLastNode)
    {
        mLastNode = sPrevNode;
    }
    
    if (aNode == mHeadNode)
    {
        [mHeadNode autorelease];
        mHeadNode = [sNextNode retain];
    }
}


- (void)removeSubNodes:(NSArray *)aNodes
{
    for (PBNode *sNode in aNodes)
    {
        [self removeSubNode:sNode];
    }
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
    if ([mMesh program])
    {
        [self pushMesh];
    }

    if (mHeadNode)
    {
        PBNode *sNode        = mHeadNode;
        PBMatrix sProjection = [mMesh projection];
        
        do
        {
            [[sNode mesh] setProjection:sProjection];
            sNode->mPushFunc(sNode, sNode->mPushSelector);
        } while ((sNode = sNode->mNextNode));
    }
}


- (void)pushSelectionWithRenderer:(PBRenderer *)aRenderer
{
    [aRenderer addNodeForSelection:self];
    
    [self pushSelectionMesh];

    if (mHeadNode)
    {
        PBNode *sNode      = mHeadNode;
        PBMatrix sProjection = [[self mesh] projection];
        
        do
        {
            [[sNode mesh] setProjection:sProjection];
            [sNode pushSelectionWithRenderer:aRenderer];
        } while ((sNode = sNode->mNextNode));
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


- (void)setGrayscale:(BOOL)aGrayscale
{
    [mTransform setGrayscale:aGrayscale];
}


- (BOOL)grayscale
{
    return [mTransform grayscale];
}


- (void)setSepia:(BOOL)aSepia
{
    [mTransform setSepia:aSepia];
}


- (BOOL)sepia
{
    return [mTransform sepia];
}


- (void)setBlur:(BOOL)aBlur
{
    [mTransform setBlur:aBlur];
}


- (BOOL)blur
{
    return [mTransform blur];
}


- (void)setLuminance:(BOOL)aLuminance
{
    [mTransform setLuminance:aLuminance];
}


- (BOOL)luminance
{
    return [mTransform luminance];
}


@end


