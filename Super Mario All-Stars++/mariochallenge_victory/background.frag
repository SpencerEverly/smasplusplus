#version 120
uniform sampler2D iChannel0;
uniform sampler2D stars;
uniform sampler2D perlin;

uniform sampler2D clouds;
uniform vec2 centre;
uniform float radius;
uniform vec2 sun;
uniform float time;
uniform vec2 rendersize;

const vec3 camdir = vec3(0,0,1);
const vec2 screensize = vec2(800,600);

vec3 drawStars()
{	
	float t = time*0.21;
	//Map coords to be from defined centre
	vec2 xy = (2*(gl_FragCoord.xy - rendersize*0.5 + sun) - 1) / rendersize.x;
	
	//Compute sun radius
	vec3 radius = normalize(vec3(xy.x, xy.y, 1.2*camdir.z));
	float sun = clamp(dot(camdir,radius),0,1);
	
	
	//Add sun and light halo
    vec3 col = 1.4 * min(vec3(1), vec3(2,1,0.5) * pow(sun, 70));
    col += 0.5 * vec3(0.8,0.9,1.2) * pow(sun, 7);

	//Sparkly stars (scrolling perlin noise)
	float sparkle = texture2D(perlin, mod(gl_FragCoord.xy/987.0 + vec2(0.087, 0.093)*t, 1)).r + texture2D(perlin, mod(gl_FragCoord.xy/371.0 + vec2(-0.071, 0.064)*t, 1)).r;
	sparkle = pow(sparkle, 3);
	//Add starfield
	col +=  (texture2D(stars, gl_TexCoord[0].xy).r * sparkle * 1) * (1-pow(sun,3));
    
	return clamp(col,0,1);
}

#define ANGLE 0.9
#define BUFFER 0.01

const mat2 rot = mat2(cos(ANGLE), -sin(ANGLE), sin(ANGLE), cos(ANGLE));

vec2 getUV(vec2 coords, float r, vec2 offset)
{
	return mod(((rot*coords*(1.0-sqrt(1.0-r))/(r) + offset) + 1) * 0.5, 1.0);
}

vec4 drawPlanet(vec3 background)
{	
	float t = time*0.01;
	
	vec2 scalefactor = rendersize/screensize;
	//Create radial position, offset by atmosphere buffer
	vec2 p = (2 * (1+BUFFER) * (gl_FragCoord.xy - rendersize*0.5 - centre*scalefactor) - 1)/(2*radius*scalefactor);
	//Calculate radius of the planet
	float r = sqrt(dot(p,p));
	
	//Convert surface UVs
	vec2 uv = getUV(p,r,vec2(t+0.3,0));
	//Convert cloud UVs
	vec2 uv2 = getUV(p,r,vec2(t*1.73+0.2,0));
	
	//Get a 0-1 boolean of what is "inside" the planet
	float planetblend = max(sign(r-1),0.0);
	//Get a 0-1 boolean of what is "inside" the atmosphere
	float atmosblend = max(sign(r-1-BUFFER),0.0);
	
	//Calculate first pass fresnel for the atmosphere
	float atmos = pow(r, 5);
	//Calculate fade out for the atmosphere
	float unatmos = clamp(1-(r-1)/BUFFER,0,1);
	
	//Get surface texture
	vec4 tex = texture2D(iChannel0, uv);
	//Get cloud texture
	vec4 cld = texture2D(clouds, uv2);
	
	//Blend surface and clouds
	tex.rgb = mix(tex.rgb, vec3(1), min(sqrt(cld.a)*1.5,1));
	//Create planet
	vec4 col = tex*(1-planetblend);
	//Adjust planet lighting
	col.rgb *=  mix(1,0.1,atmos)*clamp(r,0.5,1);
	atmos *= pow(r,18);
	
	col.rgb += background*(1-col.a);
	
	//Create atmosphere
	col += vec4(0.6, 1, 1, 0.5)*atmos*(1-atmosblend)*unatmos;
	
	//Generate sun glare
	vec2 xy = (2*(gl_FragCoord.xy - rendersize*0.5 - sun) - 1) / rendersize;
	xy.y *= 2;
	float sunr = pow(length(xy)+0.75,4);
	col += clamp((1-sunr)*0.75*(1-atmosblend),0,1);
	
	col.a = 1;
	
	return col;
}

void main()
{
	gl_FragColor = drawPlanet(drawStars());
}
