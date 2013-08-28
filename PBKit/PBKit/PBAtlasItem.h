/*
 *  PBAtlasItem.h
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 28..
 *  Copyright (c) 2013 NHN. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface PBAtlasItem : NSObject


@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) CGSize   size;
@property (nonatomic, readonly) CGFloat  dimension;


+ (id)atlasItemWithImage:(UIImage *)aImage key:(id <NSCopying>)aKey;


@end
