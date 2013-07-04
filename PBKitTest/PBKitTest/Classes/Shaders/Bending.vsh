/*
 *  Bending.vsh
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 4..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


uniform   mat4  aProjection;
attribute vec4  aPosition;
varying   vec2  vTexCoord;
attribute vec2  aTexCoord;

void main(void)
{
    vTexCoord   = aTexCoord;
	gl_Position = aProjection * aPosition;
}