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
//uniform float gTime;

//Custom variables
uniform sampler2DShadow gTexture3;
uniform float gShadowSamples;
uniform samplerCube gTexture5;

const float gTexMapScale = 1.f/1024.f;
float calculateShadow()
{
    vec3 l_coord = tShadowCoord.xyz*0.5f+0.5f;
    if(clamp(l_coord.xy,0.f,1.f) != l_coord.xy) return 1.f;
    vec2 l_sample = vec2(-gShadowSamples);
    float l_shadowIntensity = 0.f;
    l_coord.z -= 0.0025f;
    for(; l_sample.y <= gShadowSamples; l_sample.y += 1.0)
    {
        for(; l_sample.x <= gShadowSamples; l_sample.x += 1.0)
        {      
            l_shadowIntensity += textureProj(gTexture3,vec4(l_coord.xy+l_sample*gTexMapScale,l_coord.z,tShadowCoord.w));
        }
    }
    return (l_shadowIntensity/(2.f*gShadowSamples+1.f));
}

const vec3 gSkyColorA = vec3(0.73791f,0.73791f,0.73791f);
const vec3 gSkyColorB = vec3(0.099862f,0.423188f,1.f);
const float gSkyPreMix = 0.25f;
vec3 getSkyColor(float f_range) // fake irradiance
{
    return mix(gSkyColorA,mix(gSkyColorA,gSkyColorB,gSkyPreMix),f_range); 
}

//float poltergeist(in vec2 coordinate, in float seed)
//{
//    return fract(sin(dot(coordinate*seed, vec2(12.9898, 78.233)))*43758.5453);
//}

//mat4 getContrast(float contrast)
//{
//    float t = (1.0-contrast)/2.0;
//    return mat4(contrast,0,0,0, 0,contrast,0,0, 0,0,contrast,0, t,t,t,1);
//}
mat4 getSaturation(float saturation)
{
    float oneMinusSat = 1.0-saturation;
    return mat4(
        0.3086*oneMinusSat+saturation,0.3086*oneMinusSat,0.3086*oneMinusSat,0,
        0.6094*oneMinusSat,0.6094*oneMinusSat+saturation,0.6094*oneMinusSat,0,
        0.0820*oneMinusSat,0.0820*oneMinusSat,0.0820*oneMinusSat+saturation,0,
        0,0,0,1
    );
}

void main() 
{
    vec4 l_textureColor = texture(gTexture0,tUV.xy);
    if(l_textureColor.a > 0.f)
    {
        if(gLightColor.a != 0.f && gMaterialType%2 != 0)
        {
            vec3 l_normalDir = gl_FrontFacing ? tNormal : -tNormal;
            l_textureColor.rgb = mix(
                l_textureColor.rgb*getSkyColor(l_normalDir.y*0.5f+0.5f),
                l_textureColor.rgb,
                calculateShadow()*max(0.0,dot(l_normalDir,-gLightDirection)*0.5f+0.5f)
            )*gLightColor.rgb;
        }
    }
    //l_textureColor.rgb *= poltergeist(gl_FragCoord.xy,gTime);
    gOutput = getSaturation(1.5f)*l_textureColor;
}