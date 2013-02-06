/*
 *  PBContext.h
 *  PBKit
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface PBContext : NSObject


#pragma mark -


+ (EAGLContext *)context;
+ (void)performBlock:(void (^)(void))aBlock;


@end
