// Handles the silhouette effect used for locked things.

#version 120
uniform sampler2D iChannel0;

uniform float hideIfLocked;
uniform float lockedFade;

uniform vec4 lockedPathColor;

void main()
{
	vec4 unlockedColor = texture2D(iChannel0, gl_TexCoord[0].xy);
	vec4 lockedColor = mix(vec4(lockedPathColor.rgb, 1.0)*lockedPathColor.a*unlockedColor.a, vec4(0.0), hideIfLocked);

	vec4 c = mix(unlockedColor, lockedColor, lockedFade);
	
	gl_FragColor = c*gl_Color;
}