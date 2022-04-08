#version 120
uniform sampler2D iChannel0;

uniform vec2 screenSize;

uniform vec2 focus;
uniform float radius;

#include "shaders/logic.glsl"

void main()
{
	float dist = length(focus - (gl_TexCoord[0].xy * screenSize));

	gl_FragColor = mix(gl_Color,vec4(0.0), lt(dist,radius));
}