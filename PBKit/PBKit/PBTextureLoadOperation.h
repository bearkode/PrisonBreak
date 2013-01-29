/*
 *  PBTextureLoadOperation.h
 *  PBKit
 *
 *  Created by cgkim on 13. 1. 28..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class PBTexture;


@interface PBTextureLoadOperation : NSOperation

+ (id)textureLoadOperationWithTexture:(PBTexture *)aTexture;

- (id)initWithTexture:(PBTexture *)aTexture;

@end
