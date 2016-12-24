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
uniform float gShadowSamples;
uniform samplerCube gTexture5;

const vec2 gTexMapScale = vec2(1.f/1024.f);

float calculateShadow()
{
    vec3 l_coord = tShadowCoord.xyz*0.5+0.5;
    if(l_coord.x < 0.f || l_coord.x > 1.f || l_coord.y < 0.f || l_coord.y > 1.f) return 1.f;
    vec2 sumCount = vec2(0.f);
    float l_depthBiased = l_coord.z-0.00125f;
    vec2 l_sample;
    for (l_sample.y = -gShadowSamples; l_sample.y <= gShadowSamples; l_sample.y += 1.0)
    {
        for (l_sample.x = -gShadowSamples; l_sample.x <= gShadowSamples; l_sample.x += 1.0)
        {
            sumCount.x += textureProj(gTexture3,vec4(l_coord.xy+l_sample*gTexMapScale*tShadowCoord.w,l_depthBiased,tShadowCoord.w));
            sumCount.y++;
        }
    }
    return sumCount.x/sumCount.y;
}

void main() 
{
    vec4 l_textureColor = texture(gTexture0,tUV.xy);
    if(l_textureColor.a == 0.f) discard;
    if(gLightColor.a != 0.f && gMaterialType%2 != 0)
    {
        vec3 l_normalDir = gl_FrontFacing ? tNormal : -tNormal;
        l_textureColor.rgb = mix(l_textureColor.rgb*texture(gTexture5,l_normalDir).rgb, l_textureColor.rgb, calculateShadow()*max(0.0,dot(l_normalDir,-gLightDirection)*0.5f+0.5f))*gLightColor.rgb;
    }
    gOutput = l_textureColor;
}