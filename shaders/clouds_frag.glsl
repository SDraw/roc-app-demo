#version 330 core
in vec2 tUV;
in vec3 tCloudsPosition;
out vec4 gOutput;

// Default uniforms
uniform sampler2D gTexture0;
uniform vec4 gLightColor;
uniform vec3 gCameraPosition;
uniform float gTime;

const float gCloudsFadeStart = 1000.f;
const float gCloudsFadeEnd = 1500.f;
const float gCloudsFadeDif = gCloudsFadeEnd-gCloudsFadeStart;

void main() 
{
    vec2 l_distance = vec2(distance(tCloudsPosition.xz,gCameraPosition.xz),1.f);
    if(l_distance.x > gCloudsFadeStart)
    {
        l_distance.y = 1.f-(clamp(l_distance.x,gCloudsFadeStart,gCloudsFadeEnd)-gCloudsFadeStart)/gCloudsFadeDif;
    }
    gOutput = vec4(gLightColor.xyz,texture(gTexture0,mod(tUV+gTime/512.f,1.f)).r*l_distance.y);
}