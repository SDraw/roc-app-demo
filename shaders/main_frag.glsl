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
uniform vec3 gSkyGradientDown;
uniform vec3 gSkyGradientUp;

//Custom variables
uniform sampler2DShadow gTexture3;

float getShadow()
{
    float l_shadowIntensity = 1.f;
    vec3 l_shadowCoord = tShadowCoord.xyz*0.5f+0.5f;
    if(clamp(l_shadowCoord.xyz,0.f,1.f) == l_shadowCoord) // If fragment is in shadow projection
    {
        l_shadowCoord.z -= 0.00125f;
        l_shadowIntensity = texture(gTexture3,l_shadowCoord);
    }
    return l_shadowIntensity;
}

vec3 getSkyColor(in vec3 f_normal)
{
    return mix(gSkyGradientDown,gSkyGradientUp,f_normal.y*0.5f+0.5f); 
}

vec3 getShading(in vec3 f_normal)
{
    float l_theta = max(0.f,dot(f_normal,-gLightDirection)*0.5f+0.5f)*getShadow();
    vec3 l_sky = getSkyColor(f_normal);
    vec3 l_color = mix(l_sky,gLightColor.rgb,l_theta);
    return l_color;
}

void main()
{
    vec4 l_textureColor = texture(gTexture0,tUV.xy);
    if((gLightColor.a > 0.f) && (gMaterialType%2 != 0))
    {
        vec3 l_normalDir = (gl_FrontFacing ? tNormal : -tNormal);
        l_textureColor.rgb *= getShading(l_normalDir);
    }
    gOutput = l_textureColor;
}