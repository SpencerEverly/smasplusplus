#define SURFACE surf

uniform sampler2D iChannel0;

//prefix n_ marks the sampler as a normal map
uniform sampler2D n_normalmap;

uniform sampler2D metallicmap;

uniform sampler2D roughnessmap;

uniform sampler2D occlusionmap;

uniform sampler2D emissivemap;

uniform sampler2D flamemap;

uniform vec4 flamecolor;

uniform float time;

uniform float metallic = 0;

uniform float roughness = 1;

uniform float occlusion = 1;

uniform float emissive = 0;

uniform vec2 size;

//Default surface shader calculations
void surf(in fragdata data, inout surfdata o)
{
	o.albedo = texture2D( iChannel0, data.uv ) * data.color;
	
	float flame = abs(texture2D( flamemap, mod((data.worldposition.xy/size + vec2(-0.701,-0.312) + vec2(0.002,0.0013)*time), vec2(1.0)) ).r - texture2D( flamemap, mod((data.worldposition.xy/(size*1.37) + vec2(-0.0017,0.0016)*time), vec2(1.0)) ).r);
	
	flame = clamp(flame,0,1);
	//flame = floor(8*flame + 0.5)/8;
	
	o.albedo += 4 * flame * flamecolor;
	
	vec4 e = texture2D( emissivemap, data.uv );
	o.emissive = e.rgb * e.a * emissive;
	o.normal = normal2D( n_normalmap, data.uv );
	o.metallic = texture2D( metallicmap, data.uv ).r * metallic;
	o.roughness = texture2D( roughnessmap, data.uv ).r * roughness;
	o.occlusion = clamp(mix(1, texture2D( occlusionmap, data.uv ).r, occlusion),0,1);
}