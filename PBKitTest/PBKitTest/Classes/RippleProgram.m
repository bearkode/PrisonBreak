/*
 *  RippleProgram.m
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 3..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#import <PBKit.h>
#import "RippleProgram.h"


static const GLbyte gFragShaderSource[] =

"precision mediump float;\n"
"precision mediump float;\n"
"uniform sampler2D uBaseTexture;\n"
"varying vec2      vTexCoord;\n"
"uniform float     uRippleTime;\n"
"\n"
"void main()\n"
"{\n"
"    float sRippleDirection = 12.0;\n"
"    float sRipplePower     = 4.0;\n"
"    float sRippleWidth     = 0.03;\n"
"    vec2  sPosition        = -1.0 + 2.0 * vTexCoord;\n"
"    float sLength          = length(sPosition);\n"
"\n"
"    vec2 sRippleCoord      = vTexCoord + (sPosition / sLength) * cos(sLength * sRippleDirection -uRippleTime * sRipplePower) * sRippleWidth;\n"
"    vec4 sColor            = texture2D(uBaseTexture, sRippleCoord);\n"
"    if (sColor.a < 0.5)\n"
"       discard;\n"
"\n"
"    gl_FragColor           = sColor;\n"
"}\n";


static const GLbyte gVertShaderSource[] =

"uniform   mat4  aProjection;\n"
"attribute vec4  aPosition;\n"
"varying   vec2  vTexCoord;\n"
"attribute vec2  aTexCoord;\n"
"\n"
"void main(void)\n"
"{\n"
"    vTexCoord   = aTexCoord;\n"
"	gl_Position = aProjection * aPosition;\n"
"}\n";


typedef struct {
    GLint projectionLoc;
    GLint positionLoc;
    GLint texCoordLoc;
    GLint timeLoc;
} RippleLocation;


@implementation RippleProgram
{
    RippleLocation mLocation;
    GLfloat        mRippleTime;
}


#pragma mark -


- (void)bindLocation
{
    mLocation.positionLoc   = [self attributeLocation:@"aPosition"];
    mLocation.texCoordLoc   = [self attributeLocation:@"aTexCoord"];
    mLocation.projectionLoc = [self uniformLocation:@"aProjection"];
    mLocation.timeLoc       = [self uniformLocation:@"uRippleTime"];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        [self setType:kPBProgramCustom];
        [self setDelegate:self];
        [self linkVertexSource:(GLbyte *)gVertShaderSource fragmentSource:(GLbyte *)gFragShaderSource];
        [self bindLocation];
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -


- (void)updateRippleTime
{
    mRippleTime += 0.1;
}


#pragma mark - PBProgramDelegate


- (void)pbProgramCustomDraw:(PBProgram *)aProgram
                        mvp:(PBMatrix)aProjection
                   vertices:(GLfloat *)aVertices
                 coordinate:(GLfloat *)aCoordinate
{
    glUniformMatrix4fv(mLocation.projectionLoc, 1, 0, &aProjection.m[0]);
    
    glUniform1f(mLocation.timeLoc, mRippleTime);
    
    glVertexAttribPointer(mLocation.positionLoc, 3, GL_FLOAT, GL_FALSE, 0, aVertices);
    glEnableVertexAttribArray(mLocation.positionLoc);
    glVertexAttribPointer(mLocation.texCoordLoc, 2, GL_FLOAT, GL_FALSE, 0, aCoordinate);
    glEnableVertexAttribArray(mLocation.texCoordLoc);

    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDisableVertexAttribArray(mLocation.positionLoc);
    glDisableVertexAttribArray(mLocation.texCoordLoc);
}


@end