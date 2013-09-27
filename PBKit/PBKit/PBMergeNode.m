/*
 *  PBMergeNode.h
 *  PBKit
 *
 *  Created by camelkode on 13. 9. 26..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBMergeNode.h"
#import "PBMergeMesh.h"
#import "PBTexture.h"
#import "PBNodePrivate.h"


/*
 SpriteNode Array의 Node를 하나의 Node(verties, coordinate buffer를 공유하는)로 merge 한다.
 
 - 아래와 같은 경우 사용하면 performance가 kPBMeshRenderOptionDefault 옵션을 사용할 때보다 약 50% 향상된다.
 1. 동일한 texture, projection을 사용하는 Node가 많은 경우.
 2. Node가 생성된 이후 transform (scale, angle, color, position)되지 않은 경우.
 
 - 제한된 기능 및 사용 시 주의사항.
 1. 2013.9.27 기준 PBSpriteNode 객체만 지원함.
 2. Array에 포함된 Node가 서로 다른 texture_id를 사용하고 있으면 merge 실패. (projection pack node는 포함될 수 없음.)
 3. projection, color, shader program, coordinate mode 는 마지막 인덱스 Node로 대체된다.
 4. merge가 된 이후 부터 transform 변경은 지원 안됨.(즉, node array를 가지고 있지 않음.) 업데이트가 필요하면 재생성을 해야함. 추후 상황에 따라 지원될 수도 있음.
 */


@implementation PBMergeNode
{
    BOOL mMerged;
}


#pragma mark -


+ (Class)meshClass
{
    return [PBMergeMesh class];
}


+ (PBSpriteNode *)mergeSpriteNodeWithArray:(NSArray *)aNodes
{
    PBMergeNode *sMergeNode = [[[self alloc] init] autorelease];
    
    [sMergeNode mergeNodes:aNodes];
    
    return sMergeNode;
}


#pragma mark -


- (id)initWithNodeArray:(NSArray *)aNodes
{
    self = [super init];
    
    if (self)
    {
        [self mergeNodes:aNodes];
    }
    
    return self;
}


#pragma mark -


- (void)setPoint:(CGPoint)aPoint
{
    if (mMerged)
    {
        NSAssert(NO, @"Do not support changing transform after merged.");
    }
}


- (void)setScale:(PBVertex3)aScale
{
    if (mMerged)
    {
        NSAssert(NO, @"Do not support changing transform after merged.");
    }
}


- (void)setAngle:(PBVertex3)aAngle
{
    if (mMerged)
    {
        NSAssert(NO, @"Do not support changing transform after merged.");
    }
}


- (void)setColor:(PBColor *)aColor
{
    if (mMerged)
    {
        NSAssert(NO, @"Do not support changing transform after merged.");
    }
}

- (void)setAlpha:(CGFloat)aAlpha
{
    if (mMerged)
    {
        NSAssert(NO, @"Do not support changing transform after merged.");
    }
}


#pragma mark -


- (void)mergeNodes:(NSArray *)aNodes
{
    if (![aNodes count])
    {
        return;
    }
    
    PBMesh      *sCriteiaMesh = nil;
    PBMergeMesh *sMergedMesh  = (PBMergeMesh *)[self mesh];
    
    [sMergedMesh setCapacity:[aNodes count]];
    
    for (PBSpriteNode *sNode in aNodes)
    {
        if (![sNode isKindOfClass:[PBSpriteNode class]])
        {
            [sMergedMesh setCapacity:0];
            return;
        }
        
        if ([[sNode mesh] projectionPackEnabled])
        {
            [sMergedMesh setCapacity:0];
            return;
        }
        
        if  ([[sCriteiaMesh texture] handle] != [[sNode texture] handle])
        {
            [sMergedMesh setCapacity:0];
            return;
        }

        [sMergedMesh attachMesh:[sNode mesh]];
        sCriteiaMesh = [sNode mesh];
    }

    [sMergedMesh setTexture:[sCriteiaMesh texture]];
    [sMergedMesh setProgram:[sCriteiaMesh program]];
    [sMergedMesh setProjection:[sCriteiaMesh projection]];
    [sMergedMesh setColor:[sCriteiaMesh color]];
    [sMergedMesh setCoordinateMode:[sCriteiaMesh coordinateMode]];
    [sMergedMesh setMeshRenderOption:kPBMeshRenderOptionMerged];
    
    mMerged = YES;
}


@end
