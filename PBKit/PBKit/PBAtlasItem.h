/*
 *  PBAtlasItem.h
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 28..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface PBAtlasItem : NSObject


@property (nonatomic, readonly) UIImage   *image;
@property (nonatomic, readonly) NSUInteger pixelSize;
@property (nonatomic, assign)   CGFloat    atlasSize;
@property (nonatomic, assign)   CGRect     coordRect;


+ (id)atlasItemWithImage:(UIImage *)aImage key:(id <NSCopying>)aKey;


@end
