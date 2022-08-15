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
					  
	
	//innertime is the number of ticks before the inner circle appears
	const float innertime = 120;
	const float modu = 1/(1-(0.001*innertime));
	float t = max(modu*(time - innertime), 0);
	
	float wid = (time*time)/100;
	
	vec2 uv = ((gl_TexCoord[0].xy - 0.5)*0.8) + 0.5;
	vec3 c = texture2D(iChannel0, uv).rgb;
	
	float inCircle = (1-lt(d, t))*lt(d, time+wid);
	
	gl_FragColor.rgb = (1-c)*gl_Color.rgb;
	gl_FragColor.a = gl_Color.a;
	
	gl_FragColor *= mix(0, clamp((1000-time)/256, 0, 1), clamp(inCircle + lt(d, time+wid)*pow(d/t, 4), 0, 1));
}