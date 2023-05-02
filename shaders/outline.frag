#version 120
uniform sampler2D iChannel0;
uniform float thickness = 2.0;
uniform vec4 outlineColor;

#include "shaders/logic.glsl"

void main()
{
	// 
	vec2 dist = vec2(thickness/800.0,thickness/600.0);
	vec4 color = texture2D(iChannel0, gl_TexCoord[0].xy);
	
	// Get surrounding colors
	vec4 colorL = texture2D(iChannel0, gl_TexCoord[0].xy - vec2(dist.x, 0));
	vec4 colorR = texture2D(iChannel0, gl_TexCoord[0].xy + vec2(dist.x, 0));
	vec4 colorT = texture2D(iChannel0, gl_TexCoord[0].xy - vec2(0, dist.y));
	vec4 colorB = texture2D(iChannel0, gl_TexCoord[0].xy + vec2(0, dist.y));
	
	vec4 colorTL = texture2D(iChannel0, gl_TexCoord[0].xy - dist);
	vec4 colorTR = texture2D(iChannel0, gl_TexCoord[0].xy + vec2(dist.x, -dist.y));
	vec4 colorBL = texture2D(iChannel0, gl_TexCoord[0].xy + vec2(-dist.x, dist.y));
	vec4 colorBR = texture2D(iChannel0, gl_TexCoord[0].xy + dist);
	
	float alphaL = colorL.a;
	float alphaR = colorR.a;
	float alphaT = colorT.a;
	float alphaB = colorB.a;
	float alphaTL = colorTL.a;
	float alphaTR = colorTR.a;
	float alphaBL = colorBL.a;
	float alphaBR = colorBR.a;
	float surrounding = clamp(alphaL+alphaR+alphaT+alphaB+alphaTL+alphaTR+alphaBL+alphaBR, 0, 1);
	
	gl_FragColor = mix(color, outlineColor, (surrounding - color.a) * (1-color.a));
	gl_FragColor.a = color.a + surrounding;
}