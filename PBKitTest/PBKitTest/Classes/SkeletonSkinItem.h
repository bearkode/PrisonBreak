/*
 *  SkeletonSkinItem.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 9. 3..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBKit.h>
#import <Foundation/Foundation.h>


@interface SkeletonSkinItem : NSObject


@property (nonatomic, readonly) NSString    *name;
@property (nonatomic, readonly) CGSize       size;
@property (nonatomic, readonly) CGFloat      angle;
@property (nonatomic, readonly) CGPoint      offset;
@property (nonatomic, readonly) CGPoint      scale;
@property (nonatomic, retain)   PBAtlasNode *node;


- (id)initWithAttachmentName:(NSString *)aAttachmentName attributeData:(NSDictionary *)aAttributeData;


@end
