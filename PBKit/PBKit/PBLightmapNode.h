/*
 *  PBLightmapNode.h
 *  PBKit
 *
 *  Created by cgkim on 13. 8. 28..
 *  Copyright (c) 2013 NHN. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface PBLightmapNode : NSObject


@property (nonatomic, assign) CGRect rect;


- (PBLightmapNode *)insertImage:(UIImage *)aImage;

- (UIImage *)atlasImage;
- (void)draw;


@end
