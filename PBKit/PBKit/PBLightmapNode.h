/*
 *  PBLightmapNode.h
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 28..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class PBAtlasItem;


@interface PBLightmapNode : NSObject


@property (nonatomic, assign) CGRect frame;


+ (id)rootNodeWithAtlasSize:(CGFloat)aAtlasSize;

- (id)initWithAtlasSize:(CGFloat)aAtlasSize frame:(CGRect)aFrame;

- (PBLightmapNode *)insertItem:(PBAtlasItem *)aItem;
- (UIImage *)atlasImage;


@end
