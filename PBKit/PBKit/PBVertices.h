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
    GLfloat z;
} PBVertex3;


static inline PBVertex3 PBVertex3Make(GLfloat x, GLfloat y, GLfloat z)
{
    PBVertex3 p;
    
    p.x = x;
    p.y = y;
    p.z = z;
    
    return p;
}


static const PBVertex3 PBVertex3Zero = { 0, 0, 0 };


#endif
