/*
 *  SkeletonSkin.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 9. 3..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBKit.h>
#import <Foundation/Foundation.h>


@class SkeletonSkinItem;


@interface SkeletonSkin : NSObject


- (id)initWithSkinName:(NSString *)aSkinName data:(NSDictionary *)aSkinData;

- (void)generateAtlas;
- (PBAtlasNode *)atlasNodeForKey:(NSString *)aKey;
- (SkeletonSkinItem *)skinItemForAttachmentName:(NSString *)aName;


@end
