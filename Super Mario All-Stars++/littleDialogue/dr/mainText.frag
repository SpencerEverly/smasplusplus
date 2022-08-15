#version 120
uniform sampler2D iChannel0;


uniform float time;

uniform vec2 imageSize;
uniform vec2 cellSize;

uniform float ascent;
uniform float descent;


#include "shaders/logic.glsl"

void main()
{
	vec2 xy = gl_TexCoord[0].xy;
	vec4 c = texture2D(iChannel0, xy);

	// 1.0 if the pixel is white, and the original tint colour isn't. The gradient effect should only apply if it is.
	float canApply = and(ge(c.r + c.g + c.b,3.0),lt(gl_Color.r + gl_Color.g + gl_Color.b,3.0));

	float gradientPos = mod(xy.y*imageSize.y/cellSize.y,1.0);
	vec4 gradientCol = mix(vec4(gl_Color.a),gl_Color,gradientPos);

	vec4 tintCol = mix(vec4(1.0),gradientCol,canApply);
	
	gl_FragColor = c*tintCol;
}