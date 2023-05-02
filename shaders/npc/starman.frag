#version 120
uniform sampler2D iChannel0;
uniform float time;

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main()
{
	vec4 c = texture2D( iChannel0, gl_TexCoord[0].xy);
	
	float v = (c.r+c.g+c.b)*0.33;
	
	vec3 tint = hsv2rgb(vec3((time*0.01) + v*0.3, 1, 1));
	
	gl_FragColor = c.a*gl_Color;
	gl_FragColor.rgb *= tint+(c.rgb*0.75);
}