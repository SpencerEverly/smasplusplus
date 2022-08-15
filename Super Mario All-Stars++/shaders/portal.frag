#version 120
#define TAU 6.28318530716

uniform float iTime = 0;
uniform float radius = 0.75;

float spiral(vec2 p, float scl, float phase) 
{
	float r = length(p);
	r = log(r);
	float a = atan(p.y, p.x);
	return abs(mod(scl*(r-1.0/scl*a) - phase*2.0,TAU)-1.)/2.0;
}

void main()
{
	vec2 uv = gl_TexCoord[0].xy;
	
    uv -= 0.5;
	float d = length(uv)*2;
	
    float modifier1 = 1.0 / spiral(uv, 1.0, iTime + 2.3);
    float modifier2 = 1.0 / spiral(uv, 2.0, iTime);
    float modifier3 = 1.0 / spiral(uv, 3.0, iTime*2.0 - 1.0);
    float modifier4 = 1.0 / spiral(uv, 25.0 , iTime*5.0 - 2.0);
    vec3 color = vec3 (0.19, 0.43, 0.82);
	
	
	gl_FragColor = (1 - step(radius, d)) * vec4(color,1.0)
        * (modifier1 +
           modifier2 +
           modifier3 + 
           modifier4)*0.25;
		  
}