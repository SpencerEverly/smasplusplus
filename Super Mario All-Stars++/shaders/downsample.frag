#version 120

uniform sampler2D iChannel0;
uniform float amount;

void main()
{
	gl_FragColor = texture2D(iChannel0, gl_TexCoord[0].xy * amount);
}