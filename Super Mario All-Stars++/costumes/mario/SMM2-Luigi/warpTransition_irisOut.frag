// Thanks to Hoeloe for writing this shader.

#version 120
uniform sampler2D iChannel0;
uniform vec2 center;
uniform float radius;

//Do your per-pixel shader logic here.
void main()
{
	vec4 c = texture2D(iChannel0, gl_TexCoord[0].xy);
	
	gl_FragColor = c * gl_Color;
    gl_FragColor.rgb = mix(gl_FragColor.rgb, vec3(0), step(1.0, distance(gl_FragCoord.xy, center)/radius));
}