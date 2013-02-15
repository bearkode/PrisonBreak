/*
 *  PBTextureLoader.h
 *  PBKit
 *
 *  Created by bearkode on 13. 1. 25..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class PBTextureInfo;


@interface PBTextureInfoLoader : NSObject

@property (nonatomic, assign) id delegate;

- (void)setMaxConcurrentOperationCount:(NSInteger)aCount;
- (void)addTextureInfo:(PBTextureInfo *)aTextureInfo;
- (void)load;

@end


@protocol PBTextureLoaderDelegate

- (void)textureInfoLoaderWillStartLoad:(PBTextureInfoLoader *)aLoader;
- (void)textureInfoLoaderDidFinishLoad:(PBTextureInfoLoader *)aLoader;

- (void)textureInfoLoader:(PBTextureInfoLoader *)aLoader progress:(CGFloat)aProgress;
- (void)textureInfoLoader:(PBTextureInfoLoader *)aLoader didFinishLoadTextureInfo:(PBTextureInfo *)aTextureInfo;

@end
