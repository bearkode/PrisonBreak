/*
 *  PBTextureInfoManager.h
 *  PBKit
 *
 *  Created by bearkode on 13. 2. 14..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@class PBTextureInfo;


@interface PBTextureInfoManager : NSObject

+ (void)vacate;
+ (PBTextureInfo *)textureInfoWithImageName:(NSString *)aImageName;

@end
