/*
 *  PBShaderProgram
 *  PBKit
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


#pragma mark - PBShaderDataSource


//@protocol PBShaderDataSource<NSObject>
//
//@required
//- (GLbyte*)willLoadVertexShader;
//- (GLbyte*)willLoadFragmentShader;
//
//@end


#pragma mark - PBShaderProgram


@interface PBShaderProgram : NSObject
{
    GLuint mVertexShader;
    GLuint mFragmentShader;
    GLuint mProgramObject;
}


- (GLuint)linkShaderVertexSource:(GLbyte *)aVertexSource fragmentSource:(GLbyte *)aFragmentSource;


#pragma mark -


@property (nonatomic, readonly) GLuint vertexShader;
@property (nonatomic, readonly) GLuint fragmentShader;
@property (nonatomic, readonly) GLuint programObject;


@end
