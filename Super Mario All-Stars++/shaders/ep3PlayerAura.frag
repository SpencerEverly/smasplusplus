#version 120
uniform sampler2D iChannel0;
uniform sampler2D iPalette;
uniform vec2 iPaletteDimensions;
uniform float iPaletteOffsetX;

#include "shaders/logic.glsl"

void main()
{
	vec4 c = texture2D( iChannel0, gl_TexCoord[0].xy);
	vec4 c4 = c;

	for (int i=0; i < iPaletteDimensions.y; i++){
			vec4 c2 = texture2D( iPalette, vec2(iPaletteOffsetX + 0.5, i + 0.5) / iPaletteDimensions);
			vec4 c3 = texture2D( iPalette, vec2(0.5, i + 0.5) / iPaletteDimensions);
			c4 = mix(c4, c2, eq(c3.g, c.g));
	}
	c = c4;

	gl_FragColor = c * gl_Color;
}