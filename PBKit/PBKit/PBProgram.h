/*
 *  PBProgram
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


#pragma mark - PBProgram


@interface PBProgram : NSObject
{
    GLuint           mProgram;
    GLuint           mVertexShader;
    GLuint           mFragmentShader;
}


#pragma mark -


- (GLuint)linkVertexSource:(GLbyte *)aVertexSource fragmentSource:(GLbyte *)aFragmentSource;


#pragma mark -


- (void)use;


//- (void)bindAttribute:(NSString *)aAttributeName;
- (GLuint)attributeLocation:(NSString *)aAttributeName;
- (GLuint)uniformLocation:(NSString *)aUniformName;


#pragma mark -


@property (nonatomic, readonly) GLuint vertexShader;
@property (nonatomic, readonly) GLuint fragmentShader;
@property (nonatomic, readonly) GLuint program;


@end
