/*
 *  RadialParticle.fsh
 *  PBKitTest
 *
 *  Created by camelkode on 12. 12. 27..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


precision mediump float;
uniform sampler2D aTexture;
varying float     vFinishColor;

void main()
{
    gl_FragColor = vec4(vec3(1.0, 1.0, 1.0) * (1.0 - vFinishColor), 1.0) * texture2D(aTexture, gl_PointCoord);
}
