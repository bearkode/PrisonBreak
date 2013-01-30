/*
 *  Fighter.m
 *  PBKitTest
 *
 *  Created by bearkode on 13. 1. 30..
 *  Copyright (c) 2013 PrisonBreak. All rights reserved.
 *
 */

#import "Fighter.h"


@implementation Fighter
{

}


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mTexture = [[PBTexture alloc] initWithImageName:@"3fc.png"];
        [mTexture load];
        
        PBShaderProgram *sProgram = [[PBShaderManager sharedManager] textureShader];

        GLuint sProgramID = [sProgram programObject];
        
        NSLog(@"sProgram = %d", sProgramID);
        
        
        [self setProgramObject:sProgramID];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


@end
