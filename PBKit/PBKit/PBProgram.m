/*
 *  PBProgram
 *  PBKit
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012 PrisonBreak. All rights reserved.
 *
 */

#import <OpenGLES/ES2/gl.h>
#import "PBProgram.h"
#import "PBProgramManager.h"
#import "PBContext.h"
#import "PBGLObjectManager.h"


@implementation PBProgram
{
    GLuint     mProgramHandle;
    GLuint     mVertexShader;
    GLuint     mFragmentShader;
    PBLocation mLocation;
    BOOL       mBoundLocation;
}


@synthesize vertexShader   = mVertexShader;
@synthesize fragmentShader = mFragmentShader;
@synthesize programHandle  = mProgramHandle;
@synthesize location       = mLocation;


#pragma mark -


- (GLuint)compileShaderType:(GLenum)aType shaderSource:(const char*)aShaderSource
{
    GLuint sShader = GL_FALSE;
    GLint  sCompiled;

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
            
            [[PBGLObjectManager sharedManager] deleteShader:sShader];
            sShader = GL_FALSE;
        }
    }
    
    return sShader;
}


- (GLuint)linkProgram
{
    GLint sLinked;
    mProgramHandle = glCreateProgram();
    if (mProgramHandle)
    {
        glAttachShader(mProgramHandle, mVertexShader);
        glAttachShader(mProgramHandle, mFragmentShader);
        glLinkProgram(mProgramHandle);
        
        glGetProgramiv(mProgramHandle, GL_LINK_STATUS, &sLinked);
        if (!sLinked)
        {
            GLint sInfoLen = 0;
            glGetProgramiv(mProgramHandle, GL_INFO_LOG_LENGTH, &sInfoLen);
            
            if (sInfoLen > 1)
            {
                char *sInfoLog = malloc(sizeof(char) * sInfoLen);
                if (sInfoLog)
                {
                    glGetProgramInfoLog(mProgramHandle, sInfoLen, NULL, sInfoLog);
                    NSLog(@"Occured linking program error : %s", sInfoLog);
                    free (sInfoLog);
                }
            }
            
            [[PBGLObjectManager sharedManager] deleteProgram:mProgramHandle];
            mProgramHandle = 0;
        }
    }
    else
    {
        NSLog(@"glCreateProgram fail");
    }
    
    return mProgramHandle;
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
    [PBProgramManager setCurrentProgram:nil];
    
    [PBContext performBlockOnMainThread:^{
        [[PBGLObjectManager sharedManager] deleteShader:mVertexShader];
        [[PBGLObjectManager sharedManager] deleteShader:mFragmentShader];
        [[PBGLObjectManager sharedManager] deleteProgram:mProgramHandle];
    }];

    [super dealloc];
}


#pragma mark -


- (GLuint)linkVertexSource:(GLbyte *)aVertexSource fragmentSource:(GLbyte *)aFragmentSource
{
    mVertexShader   = [self compileShaderType:GL_VERTEX_SHADER shaderSource:(char *)aVertexSource];
    mFragmentShader = [self compileShaderType:GL_FRAGMENT_SHADER shaderSource:(char *)aFragmentSource];
    
    return [self linkProgram];
}


- (GLuint)linkVertexShaderFilename:(NSString *)aVShaderFilename fragmentShaderFilename:(NSString *)aFShaderFilename
{
    NSString *sVertShaderPathname = [[NSBundle mainBundle] pathForResource:aVShaderFilename ofType:@"vsh"];
    GLchar *sVertexSource = (GLchar *)[[NSString stringWithContentsOfFile:sVertShaderPathname encoding:NSUTF8StringEncoding error:nil] UTF8String];
    NSAssert(sVertexSource, @"Exception vertex shander source is nil");
    mVertexShader   = [self compileShaderType:GL_VERTEX_SHADER shaderSource:(char *)sVertexSource];
    
    NSString *sFragShaderPathname = [[NSBundle mainBundle] pathForResource:aFShaderFilename ofType:@"fsh"];
    GLchar *sFragSource = (GLchar *)[[NSString stringWithContentsOfFile:sFragShaderPathname encoding:NSUTF8StringEncoding error:nil] UTF8String];
    NSAssert(sFragSource, @"Exception fragment shander source is nil");
    mFragmentShader = [self compileShaderType:GL_FRAGMENT_SHADER shaderSource:(char *)sFragSource];
    
    return [self linkProgram];
}


#pragma mark -


- (GLuint)attributeLocation:(NSString *)aAttributeName
{
    GLint sCurrentProgram;
    glGetIntegerv(GL_CURRENT_PROGRAM, &sCurrentProgram);

    if (sCurrentProgram != mProgramHandle)
    {
        [self use];
    }
    
    GLuint sResult = glGetAttribLocation(mProgramHandle, [aAttributeName UTF8String]);
    return sResult;
}


- (GLuint)uniformLocation:(NSString *)aUniformName
{
    GLuint sResult = glGetUniformLocation(mProgramHandle, [aUniformName UTF8String]);
    
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


- (void)bindLocation
{
    if (!mBoundLocation)
    {
        mLocation.projectionLoc   = [self uniformLocation:@"aProjection"];
        mLocation.positionLoc     = [self attributeLocation:@"aPosition"];
        mLocation.texCoordLoc     = [self attributeLocation:@"aTexCoord"];
        mLocation.colorLoc        = [self attributeLocation:@"aColor"];
        
        mBoundLocation = YES;
    }
}


- (void)use
{
    if ([[PBProgramManager currentProgram] programHandle] != mProgramHandle)
    {
        glUseProgram(mProgramHandle);
        [self bindLocation];
    
        [PBProgramManager setCurrentProgram:self];
    }
}

@end
