// Original Shader by Bers
#version 120
uniform float iTime;
uniform sampler2D iChannel0;

vec2 iResolution = vec2(800, 600);

float hash( vec2 p ) {return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453123);} //Pseudo-random
float smoothNoise( in vec2 p) { //Bilinearly interpolated noise (4 samples)
    vec2 i = floor( p ); vec2 f = fract( p );	
	vec2 u = f*f*(3.0-2.0*f);
    float a = hash( i + vec2(0.0,0.0) );
	float b = hash( i + vec2(1.0,0.0) );
	float c = hash( i + vec2(0.0,1.0) );
	float d = hash( i + vec2(1.0,1.0) );
    return float(a+(b-a)*u.x+(c-a)*u.y+(a-b-c+d)*u.x*u.y)/4.;
}
//Funciton to make the noise continuous while wrapping around angle 
float rotatedMirror(float t, float r){
    //t : 0->1
    t = fract(t+r);
    return 2.*abs(t-0.5);
}
//Some continous radial perlin noise
const mat2 m2 = mat2(0.90,0.44,-0.44,0.90);
float radialPerlinNoise(float t, float d){
    // const float BUMP_MAP_UV_SCALE = 44.2;
    // d = pow(d,0.01); //Impression of speed : stretch noise as the distance increases.
    // float dOffset = -floor(iTime*10.)*0.1; //Time drift (animation)
    // vec2 p = vec2(rotatedMirror(t,0.1),d+dOffset);
    // float f1 = smoothNoise(p*BUMP_MAP_UV_SCALE);
    // p = 2.1*vec2(rotatedMirror(t,0.4),d+dOffset);
    // float f2 = smoothNoise(p*BUMP_MAP_UV_SCALE);
    // p = 3.7*vec2(rotatedMirror(t,0.8),d+dOffset);
    // float f3 = smoothNoise(p*BUMP_MAP_UV_SCALE);
    // p = 5.8*vec2(rotatedMirror(t,0.0),d+dOffset);
    // float f4 = smoothNoise(p*BUMP_MAP_UV_SCALE);
    // return (f1+0.5*f2+0.25*f3+0.125*f4)*3.;
    d = pow(d,0.01); //Impression of speed : stretch noise as the distance increases.
    float dOffset = -floor(iTime*15.)*0.1;
    vec2 p = vec2(rotatedMirror(t * 1.042359027,0.1),d+dOffset);
    p = 2.1 * vec2(rotatedMirror(t * 1.042359027,0.1),d+dOffset);
    return texture2D(iChannel0, fract(p + 0.00013123155 * (gl_FragCoord.xy + 0.5) * vec2(t * t * t))).x;
}
//Colorize function (transforms BW Intensity to color)
vec3 colorize(float f){
    f = clamp(f*.95,0.0,1.0);
    vec3 c = mix(vec3(0,0,0), vec3(1,1,1), f); //Red-Yellow Gradient
         c = mix(c, vec3(1,1,1), f*4.-3.0);      //While highlights
    vec3 cAttenuated = mix(vec3(0), c, f);       //Intensity ramp
    return cAttenuated;
}
/*vec3 colorize(float f){
    f = clamp(f,0.0,1.0);
    vec3 c = mix(vec3(1.1,0,0), vec3(1,1,0), f); //Red-Yellow Gradient
         c = mix(c, vec3(1,1,1), f*10.-9.);      //While highlights
    vec3 cAttenuated = mix(vec3(0), c, f);       //Intensity ramp
    return cAttenuated;
}*/
//Main image.
void main(){
    vec2 uv = 1.0*(gl_FragCoord.xy-0.5*vec2(iResolution.xy))/iResolution.xx;
    float d = dot(uv,uv); //Squared distance
    float t = 0.2+atan(uv.y,uv.x)/6.28; //Normalized Angle
    float v = radialPerlinNoise(t,d);
    //Saturate and offset values
    v = -2.5+v*4.5;
    //Intersity ramp from center
    v = mix(0.,v,1.0*smoothstep(0.1,0.65,d*2.0));
    //Colorize (palette remap )
    gl_FragColor.rgb = colorize(v) * 0.5;
    gl_FragColor.a = 0;
}