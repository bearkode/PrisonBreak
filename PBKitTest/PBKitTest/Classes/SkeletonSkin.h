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


- (id)initWithSkinname:(NSString *)aSkinname data:(NSDictionary *)aSkinData filename:(NSString *)aFilename;

- (PBAtlasNode *)atlasNodeForKey:(NSString *)aKey;
- (SkeletonSkinItem *)skinItemForAttachmentName:(NSString *)aName;


@end
