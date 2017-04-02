// Based on https://29a.ch/slides/2012/webglwater
#version 330 core

in vec2 tUV;
out vec4 gOutput;

// Default uniforms
uniform sampler2D gTexture0;
uniform float gTime;

vec2 getNoise(vec2 uv)
{
    vec2 l_noise;
    vec2 n0Uv = vec2(uv.x*1.4 + 0.01, uv.y + gTime*0.69);
    vec2 n1Uv = vec2(uv.x*0.5 - 0.033, uv.y*2.0 + gTime*0.12);
    vec2 n2Uv = vec2(uv.x*0.94 + 0.02, uv.y*3.0 + gTime*0.61);
    float n0 = (texture2D(gTexture0, n0Uv).w-0.5)*2.0;
    float n1 = (texture2D(gTexture0, n1Uv).w-0.5)*2.0;
    float n2 = (texture2D(gTexture0, n2Uv).w-0.5)*2.0;
    l_noise.x = clamp(n0 + n1 + n2, -1.0, 1.0);

    // Generate noisy y value
    vec2 n0UvB = vec2(uv.x*0.7 - 0.01, uv.y + gTime*0.27);
    vec2 n1UvB = vec2(uv.x*0.45 + 0.033, uv.y*1.9 + gTime*0.61);
    vec2 n2UvB = vec2(uv.x*0.8 - 0.02, uv.y*2.5 + gTime*0.51);
    float n0B = (texture2D(gTexture0, n0UvB).w-0.5)*2.0;
    float n1B = (texture2D(gTexture0, n1UvB).w-0.5)*2.0;
    float n2B = (texture2D(gTexture0, n2UvB).w-0.5)*2.0;
    l_noise.y = clamp(n0B + n1B + n2B, -1.0, 1.0);
    return l_noise;
}

void main()
{
    vec2 finalNoise = getNoise(tUV);
    float perturb = (1.0 - tUV.y) * 0.35 + 0.02;
    finalNoise = (finalNoise * perturb) + tUV - 0.02;
    
    vec4 color = texture2D(gTexture0, finalNoise);
    color = vec4(color.x*2.0, color.y*0.9, (color.y/color.x)*0.2, 1.0);
    finalNoise = clamp(finalNoise, 0.05, 1.0);
    color.w = texture2D(gTexture0, finalNoise).z*2.0;
    color.w = color.w*texture2D(gTexture0, tUV).z;
    gOutput = color;
}