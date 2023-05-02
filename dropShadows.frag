#version 120
uniform sampler2D iChannel0;

uniform sampler2D backBuffer;
uniform sampler2D frontBuffer;

uniform vec2 cameraSize;

uniform float shadowOpacity;
uniform float shadowDistance;

#include "shaders/logic.glsl"


float colorsAreEqual(vec4 a, vec4 b)
{
	return and(and(and(eq(a.r,b.r),eq(a.g,b.g)),eq(a.b,b.b)),eq(a.a,b.a)); // this is a mess lol
}

void main()
{
	vec2 oXY = gl_TexCoord[0].xy;
	vec2 sXY = oXY - shadowDistance/cameraSize;

	vec4 bO = texture2D(backBuffer,  oXY);
	vec4 fO = texture2D(frontBuffer, oXY);
	vec4 bS = texture2D(backBuffer,  sXY);
	vec4 fS = texture2D(frontBuffer, sXY);

	float pixelExistsO = colorsAreEqual(bO,fO);
	float pixelExistsS = colorsAreEqual(bS,fS);

	vec4 c = mix(vec4(0.0),vec4(0.0,0.0,0.0,shadowOpacity), and(nt(pixelExistsS),pixelExistsO));
	
	gl_FragColor = c*gl_Color;
}