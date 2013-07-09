/*
 *  FlameParticle.fsh
 *  PBKitTest
 *
 *  Created by camelkode on 13. 7. 9..
 *  Copyright (c) 2012년 PrisonBreak. All rights reserved.
 *
 */


precision mediump float;
uniform sampler2D aTexture;
varying float     vFinishColor;

void main()
{
    gl_FragColor = vec4(vec3(1.0, 0.35, 0.22) * (1.0 - vFinishColor), 0.3) * texture2D(aTexture, gl_PointCoord);
}
