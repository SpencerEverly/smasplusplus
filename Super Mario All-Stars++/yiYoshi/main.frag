// This applies the palette for the current colour.
// NOTE: this is both the normal AND starman shader, depending on the HAS_STARMAN macro. All the starman effect code is from starman.frag.

#version 120
uniform sampler2D iChannel0;


uniform sampler2D palettesImage;

uniform float currentColourY;

uniform float time;


const float COLOUR_SIMILARITY_THRESHOLD = 0.001;


#define PALETTES_COLOURS 1
#define HAS_STARMAN 0


#include "shaders/logic.glsl"


// pain
float coloursAreCloseEnough(vec4 a, vec4 b, float threshold)
{
	// le(abs(a.r-b.r), threshold)
	// le(abs(a.g-b.g), threshold)
	// le(abs(a.b-b.b), threshold)
	// le(abs(a.a-b.a), threshold)
	return and(and(and(le(abs(a.r-b.r), threshold), le(abs(a.g-b.g), threshold)), le(abs(a.b-b.b), threshold)), le(abs(a.a-b.a), threshold));
}


vec3 hsv2rgb(vec3 c) // from starman.frag
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}


void main()
{
	vec4 c = texture2D(iChannel0, gl_TexCoord[0].xy);

	for (float i = 0; i < PALETTES_COLOURS; i++)
	{
		float x = ((i+0.1)/PALETTES_COLOURS);
		vec4 originalColour = texture2D(palettesImage, vec2(x, 0.0));
		vec4 swapped = texture2D(palettesImage, vec2(x, currentColourY));

		c = mix(c,swapped, coloursAreCloseEnough(c,originalColour,COLOUR_SIMILARITY_THRESHOLD));

		//if (coloursAreCloseEnough(c,originalColour,0.05) == 1.0) { c = swapped; }
	}

	#if HAS_STARMAN == 1
		// All of this bit is, of course, from starman.frag
		float v = (c.r+c.g+c.b)*0.33;
	
		vec3 tint = hsv2rgb(vec3((time*0.02) + v*0.3, 1, 1));
		
		gl_FragColor = c.a*gl_Color;
		gl_FragColor.rgb *= tint+(c.rgb*0.75);
	#else
		gl_FragColor = c*gl_Color;
	#endif
}