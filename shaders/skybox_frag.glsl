#version 330
in vec3 tSkyPosition;
out vec4 gOutput;

// Default uniforms
uniform vec4 gLightColor;
uniform vec3 gCameraPosition;
uniform vec3 gSkyGradientDown;
uniform vec3 gSkyGradientUp;

vec3 getSkyColor(in vec3 f_normal)
{
    return mix(gSkyGradientDown,gSkyGradientUp,f_normal.y*0.5f+0.5f); 
}

void main() 
{
    vec3 l_normal = normalize(tSkyPosition-gCameraPosition);
    vec3 l_skyColor = getSkyColor(l_normal)*gLightColor.rgb;
    gOutput = vec4(l_skyColor,1.f);
}