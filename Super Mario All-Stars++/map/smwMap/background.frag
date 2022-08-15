// Apply the background to screen.

// This is done via a shader rather than repeatedly drawing an image because
// A: I hate writing code like that
// B: No matter how small the source image is, it shouldn't really make a difference to performance

#version 120
uniform sampler2D iChannel0;


uniform vec2 scrollPosition;
uniform vec2 screenSize;

uniform vec2 textureSize;
uniform float frames;
uniform float currentFrame;

void main()
{
	vec2 texSize = vec2(1.0, 1.0 / frames);
	vec2 size = texSize * textureSize;

	vec2 xy = mod(scrollPosition + gl_TexCoord[0].xy*screenSize, size) / textureSize + vec2(0.0, currentFrame * texSize.y);

	vec4 c = texture2D(iChannel0, xy);
	
	gl_FragColor = c*gl_Color;
}