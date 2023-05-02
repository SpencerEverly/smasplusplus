// Those weird transition effects are handled here

#version 120
uniform sampler2D iChannel0;


uniform sampler2D transitionTexture;
uniform float progress;

#include "shaders/logic.glsl"

void main()
{
	vec2 xy = gl_TexCoord[0].xy;

	float neededProgress = texture2D(transitionTexture, xy).r;
	vec4 c = texture2D(iChannel0, xy);

	c = (vec4(0.0,0.0,0.0,1.0) * (1-c.a)) + c*c.a; // make any transparent stuff black

	gl_FragColor = mix(vec4(0.0),c,le(neededProgress,progress));
}