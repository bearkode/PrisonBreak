/*
 *  PVRTextureView.m
 *  PBKitTest
 *
 *  Created by cgkim on 13. 1. 24..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */

#import "PVRTextureView.h"


@implementation PVRTextureView


@synthesize scale    = mScale;
@synthesize angle    = mAngle;


#pragma mark -


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        NSString *sPath = [[NSBundle mainBundle] pathForResource:@"brown" ofType:@"pvr"];
        mTexture = [[PBTexture alloc] initWithPath:sPath];
        [mTexture load];
        
        mShader  = [[PBShaderManager sharedManager] textureShader];
        [self setBackgroundColor:[PBColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
    }
    
    return self;
}


- (void)dealloc
{
    [mTexture release];

    [super dealloc];
}


#pragma mark -


- (void)rendering
{
//    [mTexture setScale:mScale];
    
    PBVertice4 sVertices;
    CGFloat    sVerticeX1 = -1;
    CGFloat    sVerticeX2 = sVerticeX1 * -1;
    CGFloat    sVerticeY1 = 1;
    CGFloat    sVerticeY2 = sVerticeY1 * -1;
    
    sVertices = PBVertice4Make(sVerticeX1, sVerticeY1, sVerticeX2, sVerticeY2);
    
    sVertices.x1 *= mScale;
    sVertices.x2 *= mScale;
    sVertices.y1 *= mScale;
    sVertices.y2 *= mScale;
    
    GLuint sProgram = [mShader programObject];
    
    glUseProgram(sProgram);
    
    PBTextureVertice sTextureVertices = generatorTextureVertice4(sVertices);
    
    GLuint sPosition = glGetAttribLocation(sProgram, "aPosition");
    GLuint sTexCoord = glGetAttribLocation(sProgram, "aTexCoord");
    GLint  sSampler  = glGetUniformLocation(sProgram, "aTexture");
    
    glVertexAttribPointer(sPosition, 2, GL_FLOAT, GL_FALSE, 0, &sTextureVertices);
    glVertexAttribPointer(sTexCoord, 2, GL_FLOAT, GL_FALSE, 0, gTextureVertices);
    glEnableVertexAttribArray(sPosition);
    glEnableVertexAttribArray(sTexCoord);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, [mTexture textureID]);
    
    glUniform1i(sSampler, 0);
    
    glEnable(GL_BLEND);
//    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, gIndices);
    glDisable(GL_BLEND);
}


@end
