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


typedef struct {
    GLint projectionLoc;
    GLint positionLoc;
    GLint texCoordLoc;
    GLint colorLoc;
    GLint selectionColorLoc;
    GLint selectModeLoc;
} PBLocation;


@interface PBProgram : NSObject


#pragma mark -


@property (nonatomic, readonly) GLuint     vertexShader;
@property (nonatomic, readonly) GLuint     fragmentShader;
@property (nonatomic, readonly) GLuint     program;
@property (nonatomic, readonly) PBLocation location;


#pragma mark -


- (GLuint)linkVertexSource:(GLbyte *)aVertexSource fragmentSource:(GLbyte *)aFragmentSource;


#pragma mark -


- (void)use;
- (void)bindLocation;

//- (void)bindAttribute:(NSString *)aAttributeName;
- (GLuint)attributeLocation:(NSString *)aAttributeName;
- (GLuint)uniformLocation:(NSString *)aUniformName;


@end
