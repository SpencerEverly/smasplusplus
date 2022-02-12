#version 120
#define PI 3.1415926535

uniform sampler2D iChannel0;
uniform float time = 0;
uniform vec2 pos;

float lt(float x, float y) 
{
  return max(sign(y - x), 0.0);
}


void main()
{
	vec2 p = gl_FragCoord.xy - pos;
	float d = length(p);
	
	vec2 uv = gl_TexCoord[0].xy;
	
	vec3 c = vec3(1) - texture2D(iChannel0, uv).rgb;
	
	gl_FragColor.rgb = c*gl_Color.rgb;
	gl_FragColor.a = gl_Color.a; 
	
	gl_FragColor *= mix(0, 1, lt(d, time));
}