/*
 *  Glowline.vsh
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 4..
 *  Copyright (c) 2013년 PrisonBreak. All rights reserved.
 *
 */


uniform   mat4 aProjection;
attribute vec4 aPosition;
varying   vec2 vCoordinate;
attribute vec2 aCoordinate;

void main(void)
{
    vCoordinate = aCoordinate;
	gl_Position = aProjection * aPosition;
}