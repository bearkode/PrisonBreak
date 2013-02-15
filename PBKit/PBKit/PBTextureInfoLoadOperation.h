/*
 *  PBTextureInfoLoadOperation.h
 *  PBKit
 *
 *  Created by bearkode on 13. 1. 28..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class PBTextureInfo;


@interface PBTextureInfoLoadOperation : NSOperation

@property (nonatomic, readonly) PBTextureInfo *textureInfo;

+ (id)operationWithTextureInfo:(PBTextureInfo *)aTextureInfo;

- (id)initWithTextureInfo:(PBTextureInfo *)aTextureInfo;

@end
