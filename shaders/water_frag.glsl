// Based on https://29a.ch/slides/2012/webglwater
#version 330 core

in vec2 tUV;
in vec3 tVertexPosition;
out vec4 gOutput;

// Default uniforms
uniform mat4 gModelMatrix;
uniform sampler2D gTexture0;
uniform vec4 gLightColor;
uniform vec3 gLightDirection;
uniform vec3 gCameraPosition;
uniform float gTime;

const vec3 g_WaterColor = vec3(0.f,105.f/255.f,148.f/255.f);
const vec3 g_WaterColorEnd = vec3(1.f);
const vec3 g_SurfaceFix = vec3(2.0,1.0,2.0);
const float g_UVSize = 160.f;

vec3 getNoise(vec2 uv)
{
    vec2 uv0 = uv/103.0+vec2(gTime/17.0,gTime/29.0);
    vec2 uv1 = uv/107.0-vec2(gTime/-19.0,gTime/31.0);
    vec2 uv2 = uv/vec2(897.0,983.0)+vec2(gTime/101.0,gTime/97.0);
    vec2 uv3 = uv/vec2(991.0,877.0)-vec2(gTime/109.0,gTime/-113.0);
    vec4 noise = texture(gTexture0,uv0)+texture(gTexture0,uv1)+texture(gTexture0,uv2)+texture(gTexture0,uv3);
    return (noise*0.5-1.0).xzy;
}

void main()
{
    vec3 l_surfaceNormal = normalize(getNoise(tUV*g_UVSize)*g_SurfaceFix);
    //vec3 l_surfaceNormal = normalize(getNoise(tVertexPosition.xz)*g_SurfaceFix);
    vec3 l_eyeToVertex = normalize(gCameraPosition-tVertexPosition);
    vec3 l_reflection = normalize(reflect(gLightDirection,l_surfaceNormal));
    float l_direction = max(0.f,dot(l_eyeToVertex, l_reflection));
    gOutput = vec4(mix(g_WaterColor,g_WaterColorEnd,l_direction),0.75f);
}