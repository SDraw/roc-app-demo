in vec2 tUV;
in vec3 tNormal;
in vec4 tShadowCoord;
in vec3 tPosition;
out vec4 gOutput;

//Default variables
uniform sampler2D gTexture0;
uniform int gMaterialType;
uniform mat4 gLightData[MAX_LIGHTS];
uniform int gLightsCount;

//Custom variables
uniform sampler2DShadow gTexture3;
uniform vec3 gSkyGradientDown;
uniform vec3 gSkyGradientUp;

float getShadow()
{
    float l_shadowIntensity = 1.f;
    vec3 l_shadowCoord = tShadowCoord.xyz*0.5f+0.5f;
    if(clamp(l_shadowCoord,0.f,1.f) == l_shadowCoord) // If fragment is in shadow projection
    {
        l_shadowCoord.z -= 0.00125f;
        l_shadowIntensity = texture(gTexture3,l_shadowCoord);
    }
    return l_shadowIntensity;
}

vec3 getDirectionalShading(in vec3 f_normal, in vec3 f_dir, in vec4 f_color)
{
    float l_theta = max(0.f,dot(f_normal,-f_dir)*0.5f+0.5f)*getShadow();
    vec3 l_sky = mix(gSkyGradientDown,gSkyGradientUp,f_normal.y*0.5f+0.5f);
    return mix(l_sky,f_color.rgb,l_theta)*f_color.w;
}
vec3 getPointLightShading(in vec3 f_normal, in vec3 f_pos, in vec4 f_color, in vec3 f_falloff)
{
    vec3 l_posDif = f_pos-tPosition;
    float l_theta = max(0.f,dot(f_normal,normalize(l_posDif))*0.5f+0.5f);
    float l_dist = length(l_posDif);
    float l_att = 1.f / (f_falloff.x + f_falloff.y*l_dist + f_falloff.z*l_dist*l_dist);
    return f_color.rgb*f_color.w*l_theta*l_att;
}
vec3 getSpotlightShading(in vec3 f_normal, in vec3 f_pos, in vec3 f_dir, in vec4 f_color, in vec3 f_falloff, in vec2 f_cutoff)
{
    vec3 l_dir = normalize(f_pos-tPosition);
    float l_diff = max(0.f,dot(f_normal,l_dir)*0.5f+0.5f);
    
    float l_theta = dot(l_dir,-f_dir);
    float l_eps = f_cutoff.x-f_cutoff.y;
    float l_intens = clamp((l_theta-f_cutoff.y)/l_eps, 0.f, 1.f);
    
    float l_dist = length(f_pos-tPosition);
    float l_att = 1.f / (f_falloff.x + f_falloff.y*l_dist + f_falloff.z*l_dist*l_dist);
    
    return f_color.rgb*f_color.w*l_diff*l_intens*l_att;
}

vec3 getShading(in vec3 f_normal)
{
    vec3 l_result = vec3(0.f);
    for(int i=0; i < gLightsCount; i++)
    {
        switch(int(gLightData[i][3].w))
        {
            case 0:
                l_result += getDirectionalShading(
                    f_normal,
                    gLightData[i][1].xyz,
                    gLightData[i][2]
                );
                break;
            case 1:
                l_result += getPointLightShading(
                    f_normal,
                    gLightData[i][0].xyz,
                    gLightData[i][2],
                    gLightData[i][3].xyz
                );
                break;
            case 2:
                l_result += getSpotlightShading(
                    f_normal,
                    gLightData[i][0].xyz,
                    gLightData[i][1].xyz,
                    gLightData[i][2],
                    gLightData[i][3].xyz,
                    vec2(gLightData[i][0].w,gLightData[i][1].w)
                );
                break;
        }
    }
    return l_result;
}

void main()
{
    vec4 l_textureColor = texture(gTexture0,tUV.xy);
    if(gMaterialType%2 != 0)
    {
        vec3 l_normalDir = (gl_FrontFacing ? tNormal : -tNormal);
        l_textureColor.rgb *= getShading(l_normalDir);
    }
    gOutput = l_textureColor;
}