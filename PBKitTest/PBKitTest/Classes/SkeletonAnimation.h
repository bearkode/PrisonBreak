/*
 *  SkeletonAnimation.h
 *  PBKitTest
 *
 *  Created by camelkode on 13. 9. 9..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBKit.h>
#import <Foundation/Foundation.h>


@interface SkeletonAnimation : NSObject


- (id)initWithAnimationName:(NSString *)aAnimationName data:(NSDictionary *)aAnimationData;


- (NSDictionary *)animationForBoneName:(NSString *)aBoneName;
- (NSUInteger)totalFrame;


@end
