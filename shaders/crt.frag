#version 120

uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds)
uniform float     iTimeDelta;            // render time (in seconds)
uniform float     iFrameRate;            // shader frame rate
uniform int       iFrame;                // shader playback frame
uniform float     iChannelTime[4];       // channel playback time (in seconds)
uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
uniform sampler2D iChannel0;             // input channel. XX = 2D/Cube
uniform vec4      iDate;                 // (year, month, day, time in seconds)

// Created by inigo quilez - iq/2013, modified for SMBX2 by SpencerlyEverly
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

#define PIXELSIZE 0.2

void main()
{
    vec2 cor;
    
    cor.x =  gl_FragCoord.x/PIXELSIZE;
    cor.y = (gl_FragCoord.y+PIXELSIZE*1.5*mod(floor(cor.x),2.0))/(PIXELSIZE*3.0);
    
    vec2 ico = floor( cor );
    vec2 fco = fract( cor );
    
    vec3 pix = step( 1.5, mod( vec3(0.0,1.0,2.0) + ico.x, 3.0 ) );
    vec3 ima = texture2D( iChannel0,PIXELSIZE*ico*vec2(1.0,3.0)/iResolution.xy ).xyz;
    
    vec3 col = pix*dot( pix, ima );

    col *= step( abs(fco.x-0.5), 0.4 );
    col *= step( abs(fco.y-0.5), 0.4 );

    col *= 1.2;
    gl_FragColor = vec4( col, 1.0 );
}