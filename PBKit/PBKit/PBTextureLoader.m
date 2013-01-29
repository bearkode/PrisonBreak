/*
 *  PBTextureLoader.m
 *  PBKit
 *
 *  Created by cgkim on 13. 1. 25..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#import "PBTextureLoader.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "PBTexture.h"
#import "PBTextureLoadOperation.h"


@implementation PBTextureLoader
{
    NSOperationQueue *mLoadQueue;
}


- (id)init
{
    self = [super init];
    
    if (self)
    {
        mLoadQueue = [[NSOperationQueue alloc] init];
        [mLoadQueue setMaxConcurrentOperationCount:2];
    }
    
    return self;
}


- (void)dealloc
{
    [mLoadQueue release];
    
    [super dealloc];
}


#pragma mark -


- (void)addTexture:(PBTexture *)aTexture
{
    PBTextureLoadOperation *sOperation = [[[PBTextureLoadOperation alloc] initWithTexture:aTexture] autorelease];
    [mLoadQueue addOperation:sOperation];
}


@end



//+ (PBTexture *)textureWithColor:(PBColor *)aColor
//{
//    GLubyte *sData = (GLubyte *) calloc(1 * 1, sizeof(GLubyte));
//
//    sData[0] = [aColor red] * 255;
//    sData[1] = [aColor green] * 255;
//    sData[2] = [aColor blue] * 255;
//    sData[3] = [aColor alpha] * 255;
//
//    GLuint sTextureID = PBCreateTexture(CGSizeMake(1, 1), sData);
//
////    glPixelStorei ( GL_UNPACK_ALIGNMENT, 1 );
////    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
////    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
////    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_MIRRORED_REPEAT);
////    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_MIRRORED_REPEAT);
////    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, 1, 1, 0, GL_RGB, GL_UNSIGNED_BYTE, sTextureData);
//
//    return [[[PBTexture alloc] initWithTextureID:sTextureID size:CGSizeMake(1, 1)] autorelease];
//}
