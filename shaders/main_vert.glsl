#version 330 core
//Default variables
layout(location = 0) in vec3 gVertexPosition;
layout(location = 1) in vec2 gVertexUV;
layout(location = 2) in vec3 gVertexNormal;
layout(location = 3) in vec4 gVertexBoneWeight;
layout(location = 4) in ivec4 gVertexBoneIndex;

//Output
out vec2 tUV;
out vec3 tNormal;
out vec4 tShadowCoord;

//Default variables
uniform mat4 gProjectionMatrix;
uniform mat4 gViewMatrix;
uniform mat4 gModelMatrix;
uniform bool gAnimated;
layout (std140) uniform gBonesUniform
{
    mat4 gBoneMatrix[227];
};

//Custom variables
uniform mat4 gShadowViewMatrix;
uniform mat4 gShadowProjectionMatrix;

void main()
{
    vec4 l_vertexPosition = vec4(gVertexPosition,1.0);
    mat4 rigMatrix = mat4(1.f);
    if(gAnimated == true)
    {
        rigMatrix = gBoneMatrix[gVertexBoneIndex.x]*gVertexBoneWeight.x;
        rigMatrix += gBoneMatrix[gVertexBoneIndex.y]*gVertexBoneWeight.y;
        rigMatrix += gBoneMatrix[gVertexBoneIndex.z]*gVertexBoneWeight.z;
        rigMatrix += gBoneMatrix[gVertexBoneIndex.w]*gVertexBoneWeight.w;
    }
    tUV = gVertexUV;
    tNormal = normalize((gModelMatrix*rigMatrix*vec4(gVertexNormal,0.0)).xyz);
    tShadowCoord = gShadowProjectionMatrix*gShadowViewMatrix*gModelMatrix*rigMatrix*l_vertexPosition;
    gl_Position = gProjectionMatrix*gViewMatrix*gModelMatrix*rigMatrix*l_vertexPosition;
}