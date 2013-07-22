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
"    if (sColor.a < 0.05)\n"
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


@implementation RippleProgram
{
    GLint   mRippleTimeLoc;
    GLfloat mRippleTime;
}


#pragma mark -


- (void)bindLocation
{
    [self setPositionLocation:[self attributeLocation:@"aPosition"]];
    [self setProjectionLocation:[self uniformLocation:@"aProjection"]];
    [self setTexCoordLocation:[self attributeLocation:@"aTexCoord"]];
    mRippleTimeLoc = [self uniformLocation:@"uRippleTime"];
}


#pragma mark -


- (id)init
{
    self = [super init];
    if (self)
    {
        [self setMode:kPBProgramModeSemiauto];
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


#pragma mark - PBProgramDrawDelegate


- (void)pbProgramWillSemiautoDraw:(PBProgram *)aProgram
{
    glUniform1f(mRippleTimeLoc, mRippleTime);
}


@end