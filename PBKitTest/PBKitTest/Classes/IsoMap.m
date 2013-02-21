/*
 *  IsoMap.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 2. 21..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "IsoMap.h"


@implementation IsoMap
{

}


- (id)initWithContentsOfFile:(NSString *)aPath
{
    self = [super init];
    
    if (self)
    {
        NSLog(@"aPath = %@", aPath);
        NSData *sData       = [NSData dataWithContentsOfFile:aPath];
        id      sJsonObject = [NSJSONSerialization JSONObjectWithData:sData options:0 error:nil];
        
        NSLog(@"sJsonObject = %@", sJsonObject);
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


@end
