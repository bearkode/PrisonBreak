/*
 *  PBProgram
 *  PBKit
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


#import "PBMatrix.h"


#pragma mark - PBShaderDataSource


//@protocol PBShaderDataSource<NSObject>
//
//@required
//- (GLbyte*)willLoadVertexShader;
//- (GLbyte*)willLoadFragmentShader;
//
//@end


#pragma mark - PBProgram


typedef enum
{
    kPBProgramBasic     = 0,
    kPBProgramCustom    = 1 << 0,
    kPBProgramSelection = 1 << 1,
    kPBProgramGray      = 1 << 2,
    kPBProgramSepia     = 1 << 3,
    kPBProgramBlur      = 1 << 4,
    kPBProgramLuminance = 1 << 5,
} PBProgramType;


typedef struct {
    GLint projectionLoc;
    GLint positionLoc;
    GLint texCoordLoc;
    GLint colorLoc;
} PBBasicLocation;


@interface PBProgram : NSObject


#pragma mark -


@property (nonatomic, assign)   id              delegate;
@property (nonatomic, readonly) GLuint          vertexShader;
@property (nonatomic, readonly) GLuint          fragmentShader;
@property (nonatomic, readonly) GLuint          programHandle;
@property (nonatomic, readonly) PBBasicLocation location;
@property (nonatomic, assign)   PBProgramType   type;


#pragma mark -


- (GLuint)linkVertexSource:(GLbyte *)aVertexSource fragmentSource:(GLbyte *)aFragmentSource;
- (GLuint)linkVertexShaderFilename:(NSString *)aVShaderFilename fragmentShaderFilename:(NSString *)aFShaderFilename;


#pragma mark -


- (void)use;
- (void)bindLocation;

//- (void)bindAttribute:(NSString *)aAttributeName;
- (GLuint)attributeLocation:(NSString *)aAttributeName;
- (GLuint)uniformLocation:(NSString *)aUniformName;


@end


#pragma mark - PBProgramDelegate;


@protocol PBProgramDelegate <NSObject>

@required

- (void)pbProgramCustomDraw:(PBProgram *)aProgram
                        mvp:(PBMatrix)aProjection
                   vertices:(GLfloat *)aVertices
                 coordinate:(GLfloat *)aCoordinate;
@end
