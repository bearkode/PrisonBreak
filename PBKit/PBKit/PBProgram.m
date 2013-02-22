/*
 *  PBProgram
 *  PBKit
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


#import "PBKit.h"


@implementation PBProgram
{
    GLuint      mProgram;
    GLuint      mVertexShader;
    GLuint      mFragmentShader;
    PBLocation  mLocation;
}


@synthesize vertexShader   = mVertexShader;
@synthesize fragmentShader = mFragmentShader;
@synthesize program        = mProgram;
@synthesize location       = mLocation;


#pragma mark -


- (GLuint)compileShaderType:(GLenum)aType shaderSource:(const char*)aShaderSource
{
    __block GLuint sShader = GL_FALSE;

//    [PBContext performBlockOnMainThread:^{
        GLint sCompiled;

        sShader = glCreateShader(aType);
        if (sShader)
        {
            glShaderSource(sShader, 1, (const GLchar **)&aShaderSource, NULL);
            glCompileShader(sShader);
            
            glGetShaderiv(sShader, GL_COMPILE_STATUS, &sCompiled);
            if (!sCompiled)
            {
                GLint sInfoLen = 0;
                glGetShaderiv(sShader, GL_INFO_LOG_LENGTH, &sInfoLen);
                if (sInfoLen > 1)
                {
                    char *sInfoLog = malloc(sizeof(char) * sInfoLen);
                    if (sInfoLog)
                    {
                        glGetShaderInfoLog(sShader, sInfoLen, NULL, sInfoLog);
                        NSLog(@"Occured shader compile error : %s", sInfoLog);
                        free (sInfoLog);
                    }
                }
                
                glDeleteShader(sShader);
                sShader = GL_FALSE;
            }
        }
//    }];
    
    return sShader;
}


#pragma mark -


- (id)init
{
    self = [super init];

    if (self)
    {
    }
    
    return self;
}


- (void)dealloc
{
    [PBContext performBlockOnMainThread:^{
        if (mVertexShader)
        {
            glDeleteShader(mVertexShader);
        }
        
        if (mFragmentShader)
        {
            glDeleteShader(mFragmentShader);
        }
        
        if (mProgram)
        {
            glDeleteProgram(mProgram);
        }
    }];

    [super dealloc];
}


#pragma mark -


- (GLuint)linkVertexSource:(GLbyte *)aVertexSource fragmentSource:(GLbyte *)aFragmentSource
{
    mVertexShader   = [self compileShaderType:GL_VERTEX_SHADER shaderSource:(char *)aVertexSource];
    mFragmentShader = [self compileShaderType:GL_FRAGMENT_SHADER shaderSource:(char *)aFragmentSource];

//    [PBContext performBlockOnMainThread:^{
    
        GLint sLinked;
        
        mProgram = glCreateProgram();
        if (mProgram)
        {
            glAttachShader(mProgram, mVertexShader);
            glAttachShader(mProgram, mFragmentShader);
            glLinkProgram(mProgram);
            
            glGetProgramiv(mProgram, GL_LINK_STATUS, &sLinked);
            if (!sLinked)
            {
                GLint sInfoLen = 0;
                glGetProgramiv(mProgram, GL_INFO_LOG_LENGTH, &sInfoLen);
                
                if (sInfoLen > 1)
                {
                    char *sInfoLog = malloc(sizeof(char) * sInfoLen);
                    if (sInfoLog)
                    {
                        glGetProgramInfoLog(mProgram, sInfoLen, NULL, sInfoLog);
                        NSLog(@"Occured linking program error : %s", sInfoLog);
                        free (sInfoLog);
                    }
                }
                
                glDeleteProgram(mProgram);
                mProgram = nil;
            }
        }
        else
        {
            NSLog(@"glCreateProgram fail");
        }
//    }];
    
    return mProgram;
}


#pragma mark -


- (GLuint)attributeLocation:(NSString *)aAttributeName
{
    GLint sCurrentProgram;
    glGetIntegerv(GL_CURRENT_PROGRAM, &sCurrentProgram);

    if (sCurrentProgram != mProgram)
    {
        glUseProgram(mProgram);
    }
    __block GLuint sResult;
    
    [PBContext performBlockOnMainThread:^{
        sResult = glGetAttribLocation(mProgram, [aAttributeName UTF8String]);
    }];
    
    return sResult;
}


- (GLuint)uniformLocation:(NSString *)aUniformName
{
    __block GLuint sResult;
    
    [PBContext performBlockOnMainThread:^{
        sResult = glGetUniformLocation(mProgram, [aUniformName UTF8String]);
    }];
    
    return sResult;
}


//- (void)bindAttribute:(NSString *)aAttributeName
//{
//    if (![mAttributes containsObject:aAttributeName])
//    {
//        [mAttributes addObject:aAttributeName];
//        glBindAttribLocation(mProgram, [mAttributes indexOfObject:aAttributeName], [aAttributeName UTF8String]);
//    }
//}


- (void)use
{
//    [PBContext performBlockOnMainThread:^{
        glUseProgram(mProgram);
//    }];
}


- (void)bindLocation
{
    mLocation.projectionLoc     = [self uniformLocation:@"aProjection"];
    mLocation.positionLoc       = [self attributeLocation:@"aPosition"];
    mLocation.texCoordLoc       = [self attributeLocation:@"aTexCoord"];
    mLocation.colorLoc          = [self attributeLocation:@"aColor"];
    mLocation.selectionColorLoc = [self attributeLocation:@"aSelectionColor"];
    mLocation.selectModeLoc     = [self attributeLocation:@"aSelectMode"];
    mLocation.scaleLoc          = [self attributeLocation:@"aScale"];
    mLocation.angleLoc          = [self attributeLocation:@"aAngle"];
    mLocation.translateLoc      = [self attributeLocation:@"aTranslate"];
    
//    mLocation.grayFilterLoc     = [self attributeLocation:@"aGrayScaleFilter"];
//    mLocation.sepiaFilterLoc    = [self attributeLocation:@"aSepiaFilter"];
//    mLocation.lumiFilterLoc     = [self attributeLocation:@"aLuminanceFilter"];
//    mLocation.blurFilterLoc     = [self attributeLocation:@"aBlurFilter"];
}


@end
