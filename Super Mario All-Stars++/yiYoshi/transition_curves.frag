// Those weird transition effects are handled here

#version 120
uniform sampler2D iChannel0;

uniform float transitionMin;
uniform float transitionMax;

uniform float transitionLoopHeight;


const float twoPi = 6.28318530718;


#include "shaders/logic.glsl"

void main()
{
	vec2 xy = gl_TexCoord[0].xy;
	float transitionEndX = mix(transitionMin,transitionMax,(cos((xy.y*twoPi)/transitionLoopHeight)+1)*0.5);

	vec4 c = texture2D(iChannel0, xy);

	c = (vec4(0.0,0.0,0.0,1.0) * (1-c.a)) + c*c.a; // make any transparent stuff black

	gl_FragColor = mix(vec4(0.0),c,ge(transitionEndX,xy.x));
}