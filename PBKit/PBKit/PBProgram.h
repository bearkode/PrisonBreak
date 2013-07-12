/*
 *  PBProgram
 *  PBKit
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


#import "PBMatrix.h"
#import "PBProgramEffect.h"


#pragma mark - PBShaderDataSource


//@protocol PBShaderDataSource<NSObject>
//
//@required
//- (GLbyte*)willLoadVertexShader;
//- (GLbyte*)willLoadFragmentShader;
//
//@end


#pragma mark - PBProgram


typedef struct {
    GLint projectionLoc;
    GLint positionLoc;
    GLint texCoordLoc;
    GLint colorLoc;
} PBProgramLocation;


@interface PBProgram : NSObject


#pragma mark -


@property (nonatomic, assign)   id                delegate;
@property (nonatomic, readonly) GLuint            vertexShader;
@property (nonatomic, readonly) GLuint            fragmentShader;
@property (nonatomic, readonly) GLuint            programHandle;
@property (nonatomic, readonly) PBProgramLocation location;
@property (nonatomic, assign)   PBProgramMode     mode;


#pragma mark -


- (GLuint)linkVertexSource:(GLbyte *)aVertexSource fragmentSource:(GLbyte *)aFragmentSource;
- (GLuint)linkVertexShaderFilename:(NSString *)aVShaderFilename fragmentShaderFilename:(NSString *)aFShaderFilename;


#pragma mark -


- (void)use;
- (void)bindLocation;
- (void)setProjectionLocation:(GLint)aLocation;
- (void)setPositionLocation:(GLint)aLocation;
- (void)setTexCoordLocation:(GLint)aLocation;
- (void)setColorLocation:(GLint)aLocation;


//- (void)bindAttribute:(NSString *)aAttributeName;
- (GLuint)attributeLocation:(NSString *)aAttributeName;
- (GLuint)uniformLocation:(NSString *)aUniformName;


@end