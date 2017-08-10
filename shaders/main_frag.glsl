#version 330 core
in vec2 tUV;
in vec3 tNormal;
in vec4 tShadowCoord;
out vec4 gOutput;

//Default variables
uniform sampler2D gTexture0;
uniform vec4 gLightColor;
uniform vec3 gLightDirection;
uniform int gMaterialType;

//Custom variables
uniform sampler2DShadow gTexture3;
//uniform float gShadowSamples;
uniform samplerCube gTexture5;

const float gTexMapScale = 1.f/1024.f;
float getShadow()
{
    float l_shadowIntensity = 0.f;
    vec3 l_shadowCoord = tShadowCoord.xyz*0.5f+0.5f;
    l_shadowCoord.z -= 0.00125f;
    return texture(gTexture3,l_shadowCoord);
}

float getShading(in vec3 f_normal)
{
    return max(0.0,dot(f_normal,-gLightDirection)*0.5f+0.5f);
}

const vec3 gSkyColorA = vec3(0.73791f,0.73791f,0.73791f);
const vec3 gSkyColorB = vec3(0.099862f,0.423188f,1.f);
const vec3 gSkyMix = mix(gSkyColorA,gSkyColorB,0.25f);
vec3 getSkyColor(in vec3 f_normal)
{
    return mix(gSkyColorA,gSkyMix,f_normal.y*0.5f+0.5f); 
}

void main() 
{
    vec4 l_textureColor = texture(gTexture0,tUV.xy);
    if((gLightColor.a > 0.f) && (gMaterialType%2 != 0))
    {
        vec3 l_normalDir = gl_FrontFacing ? tNormal : -tNormal;
        l_textureColor.rgb = mix(
            l_textureColor.rgb*getSkyColor(l_normalDir),
            l_textureColor.rgb,
            getShadow()*getShading(l_normalDir)
        )*gLightColor.rgb;
    }
    gOutput = l_textureColor;
}