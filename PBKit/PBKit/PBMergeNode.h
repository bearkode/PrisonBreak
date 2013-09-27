/*
 *  PBMergeNode.m
 *  PBKit
 *
 *  Created by camelkode on 13. 9. 26..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */


#import "PBSpriteNode.h"


@interface PBMergeNode : PBSpriteNode


+ (PBSpriteNode *)mergeSpriteNodeWithArray:(NSArray *)aNodes;


- (id)initWithNodeArray:(NSArray *)aNodes;


- (void)mergeNodes:(NSArray *)aNodes;


@end
