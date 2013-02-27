/*
 *  PBVertices.h
 *  PBKit
 *
 *  Created by camelkode on 13. 1. 14..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


#ifndef PBVertices_h
#define PBVertices_h


typedef struct {
    GLfloat x;
    GLfloat y;
} PBVertex2;


typedef struct {
    GLfloat x;
    GLfloat y;
    GLfloat z;
} PBVertex3;


typedef struct {
    GLfloat x1;
    GLfloat x2;
    GLfloat y1;
    GLfloat y2;
} PBVertex4;


static inline PBVertex2 PBVertex2Make(GLfloat x, GLfloat y)
{
    PBVertex2 p;
    
    p.x = x;
    p.y = y;
    
    return p;
}


static inline PBVertex3 PBVertex3Make(GLfloat x, GLfloat y, GLfloat z)
{
    PBVertex3 p;
    
    p.x = x;
    p.y = y;
    p.z = z;
    
    return p;
}


static inline PBVertex4 PBVertex4Make(GLfloat x1, GLfloat y1, GLfloat x2, GLfloat y2)
{
    PBVertex4 p;
    
    p.x1 = x1;
    p.x2 = x2;
    p.y1 = y1;
    p.y2 = y2;
    
    return p;
}


#endif
