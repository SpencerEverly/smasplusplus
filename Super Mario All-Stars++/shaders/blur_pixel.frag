#version 120
uniform sampler2D iChannel0;
uniform vec3 iResolution;
uniform float scale;
uniform float t;

void main() 
{ 
  vec2 uv = gl_TexCoord[0].xy;
  
  float ar = iResolution.y/iResolution.x;
  
  vec3 tc = vec3(1.0, 0.0, 0.0);
  
  float dx = scale*(1./iResolution.x);
  float dy = scale*ar*(1./iResolution.y);
	
  vec2 coord = vec2(dx*floor(uv.x/dx),
                    dy*floor(uv.y/dy));
  tc = texture2D(iChannel0, (coord*(0.995-vec2(dx,dy)) + vec2(dx,dy))).rgb;
  gl_FragColor = vec4(tc, 1.0);
  gl_FragColor.rgb *= t;
}