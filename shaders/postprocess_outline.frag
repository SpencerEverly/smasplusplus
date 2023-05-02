#version 120
uniform sampler2D iChannel0;

uniform vec2 size;

void main()
{
	vec3 texel = vec3(1.0/size.x,1.0/size.y,0);
	vec4 c = texture2D( iChannel0, gl_TexCoord[0].xy);
	
	vec4 cr = texture2D( iChannel0, clamp(gl_TexCoord[0].xy + texel.xz,0.001,0.999));
	vec4 cl = texture2D( iChannel0, clamp(gl_TexCoord[0].xy - texel.xz,0.001,0.999));
	vec4 cd = texture2D( iChannel0, clamp(gl_TexCoord[0].xy + texel.zy,0.001,0.999));
	vec4 cu = texture2D( iChannel0, clamp(gl_TexCoord[0].xy - texel.zy,0.001,0.999));
	
	float ar = cr.a;
	float al = cl.a;
	float ad = cd.a;
	float au = cu.a;
	
	float inside = clamp(ar+al+ad+au, 0, 1);
	
	float outline = 0;
	if(c.a == 0 && inside > 0)
	{
		outline = 1;
	}
	
	vec3 outlinecol = pow(max(max(cr.rgb,cl.rgb),max(cd.rgb,cu.rgb)),vec3(6));
	
	gl_FragColor = mix(c*gl_Color, vec4(clamp(outlinecol*gl_Color.rgb*0.4 - 0.1,0,1),1), outline);
}