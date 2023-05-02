#version 120

#include "shaders/logic.glsl"

#define PI2 6.2832

uniform sampler2D iChannel0;

uniform vec2 iOffset;
uniform float iTime;

uniform float iDistortion;
uniform float iDistortionX;
uniform float iDistortionY;

uniform float iFrequency;
uniform float iAmplitude;

uniform float iMoveX;
uniform float iMoveY;

uniform float iInterlacingOn;
uniform float iInterlace2;
uniform float iInterlaceSize;

uniform float iAnimationPhase;
uniform float iAnimationSpeed;

uniform float iVerticalWobbleOn;

uniform float iOscillationYFrequency;
uniform float iOscillationYAmplitude;

uniform sampler2D iPalette;
uniform float iPaletteSpeed;
uniform int iPaletteHeight;

uniform vec4 iTint;

void main() {
    vec4 c;
    vec2 wp = gl_TexCoord[0].xy;
    wp.x = sin(wp.x *3);
    wp.y = sin(wp.y * 3);
    float x_distort = iDistortion * (wp.y - iDistortionY) * (wp.y - iDistortionY) * (wp.x - iDistortionX);
    float y_distort = iDistortion * (wp.x - iDistortionX) * (wp.x - iDistortionX) * (wp.y - iDistortionY);

    float xBlock = sin(wp.y * iFrequency + iTime * iAnimationSpeed + PI2 * iAnimationPhase) * iAmplitude - iMoveX * iTime;
    float yBlockA = y_distort - iMoveY * iTime + sin(wp.y * iOscillationYFrequency + iTime * iAnimationSpeed + PI2) * iOscillationYAmplitude;
    float yBlockB = y_distort - iMoveY * iTime + sin(wp.y * iOscillationYFrequency + iTime * iAnimationSpeed + PI2) * iOscillationYAmplitude;
    float yBlockC = y_distort - iMoveY * iTime + sin(wp.y * iOscillationYFrequency + iTime * iAnimationSpeed ) * iOscillationYAmplitude;

    float yBlockZ = cos(wp.x * iFrequency + iTime * iAnimationSpeed + PI2 * iAnimationPhase) * iAmplitude;

    // interlacing on
    vec2 uva = gl_TexCoord[0].xy +
        vec2(
            x_distort + xBlock,
                mix(
                    yBlockA,
                    yBlockA + yBlockZ,
                    iVerticalWobbleOn
                )
            );
    vec4 a = texture2D(iChannel0, vec2(mod(uva.x, 1), mod(uva.y, 1)));

    vec2 uvb = gl_TexCoord[0].xy + vec2(
            x_distort - xBlock,
            mix(yBlockB, yBlockB + yBlockZ , iVerticalWobbleOn));
    vec4 b = texture2D(iChannel0, vec2(mod(uvb.x, 1), mod(uvb.y, 1)));

    c = mix(b, a, lt(mod(gl_FragCoord.y, iInterlace2), iInterlaceSize));
    vec2 uvd = gl_TexCoord[0].xy + 
            vec2(
                x_distort + xBlock,
                mix(yBlockC, yBlockC + yBlockZ,
                    iVerticalWobbleOn
                )
            );
    vec4 d = texture2D(iChannel0, vec2(mod(uvd.x, 1), mod(uvd.y, 1)));
    c = mix(d, c, iInterlacingOn);
    vec4 col;
    for (int i=0; i<iPaletteHeight; ++i) {
        vec4 palettePos = texture2D(iPalette, vec2(0, i/iPaletteHeight));
        col.rgb = mix(col.rgb, texture2D(iPalette, vec2(mod(iTime * iPaletteSpeed, 1), i/iPaletteHeight)).rgb, and(and(eq(c.r, palettePos.r), eq(c.g, palettePos.g)), eq(c.b, palettePos.b)));
    }

    c.rgb = mix(c.rgb, col.rgb, gt(col.r + col.g + col.b, 0)) * iTint.rgb;
    gl_FragColor = c * gl_Color * vec4(.3,.3,.3,0);
}