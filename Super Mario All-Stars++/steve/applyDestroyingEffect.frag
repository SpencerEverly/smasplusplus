// Puts the destroying image onto a block.

#version 120
uniform sampler2D iChannel0;

uniform float blockSourceY;
uniform vec2 blockImageSize;

uniform sampler2D destroyingImage;
uniform vec2 destroyingSize;
uniform float destroyingFrames;
uniform float destroyingFrame;


void main()
{
	vec2 destroyingXY = (gl_TexCoord[0].xy-vec2(0.0,blockSourceY))*blockImageSize/destroyingSize;
	float destroyingHeight = 1.0/destroyingFrames;

	destroyingXY = mod(destroyingXY,vec2(1.0,destroyingHeight));
	destroyingXY.y += (destroyingFrame*destroyingHeight);


	vec4 b = texture2D(iChannel0, gl_TexCoord[0].xy);
	vec4 d = texture2D(destroyingImage, destroyingXY);
	
	vec4 c = d*b.a;

	gl_FragColor = c*gl_Color;
}