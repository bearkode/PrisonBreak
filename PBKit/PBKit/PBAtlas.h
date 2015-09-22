/*
 *  PBAtlas.h
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 28..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class PBTexture;
@class PBAtlasItem;


@interface PBAtlas : NSObject


@property (nonatomic, readonly) PBTexture *texture;


+ (id)atlas;


- (void)addImage:(UIImage *)aImage forKey:(id <NSCopying>)aKey;
- (BOOL)generate;
- (CGSize)size;


- (PBAtlasItem *)itemForKey:(id <NSCopying>)aKey;


@end
