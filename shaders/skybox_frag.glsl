#version 330 core
in vec3 tSkyPosition;
out vec4 gOutput;

// Default uniforms
uniform vec4 gLightColor;
uniform vec3 gCameraPosition;

const vec3 gSkyColorA = vec3(0.73791f,0.73791f,0.73791f);
const vec3 gSkyColorB = vec3(0.099862f,0.423188f,1.f);
const float gSkyPreMix = 0.25f;
vec3 getSkyColor(in vec3 f_normal)
{
    return mix(gSkyColorA,mix(gSkyColorA,gSkyColorB,gSkyPreMix),f_normal.y*0.5f+0.5f); 
}

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
    gOutput = getSaturation(1.5f)*vec4(getSkyColor(normalize(tSkyPosition-gCameraPosition))*gLightColor.rgb,1.f);
}