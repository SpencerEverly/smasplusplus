#version 120
uniform sampler2D iChannel0;
uniform vec3 iResolution;
uniform float blend;

#define mSize 11
#define kSize ((mSize-1)/2)

float normpdf(in float x, in float sigma)
{
	return 0.39894*exp(-0.5*x*x/(sigma*sigma))/sigma;
}

float kernel[mSize];

void main()
{
	vec2 uv = gl_TexCoord[0].xy;
	vec3 c = texture2D(iChannel0, uv).rgb;
		
	//declare stuff
	vec3 final_colour = vec3(0.0);
		
	//create the 1-D kernel
	float sigma = 7.0;
	float Z = 0.0;
	for (int j = 0; j <= kSize; ++j)
	{
		kernel[kSize+j] = kernel[kSize-j] = normpdf(float(j), sigma);
	}
		
	//get the normalization factor (as the gaussian has been clamped)
	for (int j = 0; j < mSize; ++j)
	{
		Z += kernel[j];
	}
		
	//read out the texels
	for (int i=-kSize; i <= kSize; ++i)
	{
		for (int j=-kSize; j <= kSize; ++j)
		{
			final_colour += kernel[kSize+j] * kernel[kSize+i] * texture2D(iChannel0, clamp(uv+vec2(float(i),float(j)) / (2*iResolution.xy), 0, 1)).rgb;
	
		}
	}
		
		
	gl_FragColor = vec4(mix(c,final_colour/(Z*Z),blend), 1.0)*gl_Color.a;
}