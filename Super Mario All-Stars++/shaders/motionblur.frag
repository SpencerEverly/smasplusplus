#version 120

#define STEPS 8

uniform sampler2D iChannel0;
uniform sampler2D last;
uniform vec2 motionVector;

void main()
{
	vec4 c = texture2D( iChannel0, gl_TexCoord[0].xy);
	vec2 v = motionVector/vec2(800,600);
	float tot = 1;
	for(int i=1; i<=STEPS; i++)
	{
		c += texture2D(last, clamp(gl_TexCoord[0].xy + v*i*i/float(STEPS*STEPS),0,1)) * (STEPS+1-i);
		tot += (STEPS+1-i);
	}
	c /= tot;
	gl_FragColor = c*gl_Color;
}