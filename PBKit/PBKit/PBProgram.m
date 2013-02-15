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


@synthesize vertexShader   = mVertexShader;
@synthesize fragmentShader = mFragmentShader;
@synthesize program        = mProgram;


#pragma mark -


- (GLuint)compileShaderType:(GLenum)aType shaderSource:(const char*)aShaderSource
{
    __block GLuint sShader;
    GLint  sCompiled;
    
    [PBContext performBlock:^{
        sShader = glCreateShader(aType);
    }];
    
    if (!sShader)
    {
        return GL_FALSE;
    }
    
    glShaderSource(sShader, 1, &aShaderSource, NULL);
    glCompileShader(sShader);

    glGetShaderiv(sShader, GL_COMPILE_STATUS, &sCompiled);
    if (!sCompiled)
    {
        GLint sInfoLen = 0;
        glGetShaderiv(sShader, GL_INFO_LOG_LENGTH, &sInfoLen);
        if (sInfoLen > 1)
        {
            char* sInfoLog = malloc(sizeof(char) * sInfoLen);
            glGetShaderInfoLog(sShader, sInfoLen, NULL, sInfoLog);
            NSLog(@"Occured shader compile error : %s", sInfoLog);
            free (sInfoLog);
        }
        
        [PBContext performBlock:^{
            glDeleteShader(sShader);
        }];

        return GL_FALSE;
    }

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
    [PBContext performBlock:^{

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
    GLint sLinked;
    
    mVertexShader   = [self compileShaderType:GL_VERTEX_SHADER shaderSource:(char *)aVertexSource];
    mFragmentShader = [self compileShaderType:GL_FRAGMENT_SHADER shaderSource:(char *)aFragmentSource];
    
    [PBContext performBlock:^{
        mProgram = glCreateProgram();
    }];
    
    if (!mProgram)
    {
        NSLog(@"glCreateProgram fail");
        return GL_FALSE;
    }
    
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
            char* sInfoLog = malloc(sizeof(char) * sInfoLen);
            glGetProgramInfoLog(mProgram, sInfoLen, NULL, sInfoLog);
            NSLog(@"Occured linking program error : %s", sInfoLog);
            free (sInfoLog);
        }
        
        glDeleteProgram(mProgram);
        return GL_FALSE;
    }
    
    return mProgram;
}


#pragma mark -


- (void)use
{
    glUseProgram(mProgram);
}


//- (void)bindAttribute:(NSString *)aAttributeName
//{
//    if (![mAttributes containsObject:aAttributeName])
//    {
//        [mAttributes addObject:aAttributeName];
//        glBindAttribLocation(mProgram, [mAttributes indexOfObject:aAttributeName], [aAttributeName UTF8String]);
//    }
//}


- (GLuint)attributeLocation:(NSString *)aAttributeName
{
    return glGetAttribLocation(mProgram, [aAttributeName UTF8String]);
}


- (GLuint)uniformLocation:(NSString *)aUniformName
{
    return glGetUniformLocation(mProgram, [aUniformName UTF8String]);
}


@end
