/*
 *  PBTextureManager.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 14..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class PBTexture;


@interface PBTextureManager : NSObject


+ (void)vacate;


+ (PBTexture *)textureWithImageName:(NSString *)aImageName;
+ (PBTexture *)textureWithImage:(UIImage *)aImage key:(NSString *)aKey;


@end
