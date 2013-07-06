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


typedef NS_ENUM(NSUInteger, PBProgramType)
{
    kPBProgramBasic          = 0,
    kPBProgramSelection      = 1 << 0,
    kPBProgramGray           = 1 << 1,
    kPBProgramSepia          = 1 << 2,
    kPBProgramBlur           = 1 << 3,
    kPBProgramLuminance      = 1 << 4,

    kPBProgramCustom         = 0x00FF0000, // transform without meshdata (vertex, coordinate, projection)
    kPBProgramCustomWithMesh = 0xFF000000  // available transform meshdata
};


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
@property (nonatomic, assign)   PBProgramType     type;


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


#pragma mark - PBProgramDelegate;


@protocol PBProgramDelegate <NSObject> // for PBEffectNode

@optional

// for kPBProgramCustom. mvp, vertices and coordinates are already applied.
- (void)pbProgramWillCustomDraw:(PBProgram *)aProgram;

// for kPBProgramCustomWithMesh. Direct mvp, vertices and projection must apply.
- (void)pbProgramWillCustomDraw:(PBProgram *)aProgram
                     projection:(PBMatrix)aProjection
                     queueCount:(NSUInteger)aQueueCount
                       vertices:(GLfloat *)aVertices
                     coordinate:(GLfloat *)aCoordinate
                        indices:(GLushort *)aIndices;
@end
