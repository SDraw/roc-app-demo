#version 330 core
in vec3 tSkyPosition;
out vec4 gOutput;

// Default uniforms
uniform vec4 gLightColor;
uniform vec3 gCameraPosition;

const vec3 gSkyColorA = vec3(0.73791f,0.73791f,0.73791f);
const vec3 gSkyColorB = vec3(0.099862f,0.423188f,1.f);
const vec3 gSkyMix = mix(gSkyColorA,gSkyColorB,0.25f);
vec3 getSkyColor(in vec3 f_normal)
{
    return mix(gSkyColorA,gSkyMix,f_normal.y*0.5f+0.5f); 
}

void main() 
{
    gOutput = vec4(getSkyColor(normalize(tSkyPosition-gCameraPosition))*gLightColor.rgb,1.f);
}