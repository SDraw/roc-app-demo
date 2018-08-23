#version 330 core
//Default variables
layout(location = 0) in vec3 gVertexPosition;
layout(location = 1) in vec3 gVertexNormal;
layout(location = 2) in vec2 gVertexUV;
layout(location = 3) in vec4 gVertexBoneWeight;
layout(location = 4) in ivec4 gVertexBoneIndex;

//Output
out vec2 tUV;
out vec3 tNormal;
out vec4 tShadowCoord;

//Default variables
uniform mat4 gViewProjectionMatrix;
uniform mat4 gModelMatrix;
uniform bool gAnimated;
layout (std140) uniform gBonesUniform
{
    mat4 gBoneMatrix[227];
};

//Custom variables
uniform mat4 gShadowViewProjectionMatrix;

void main()
{
    vec4 l_vertexPosition = vec4(gVertexPosition,1.0);
    mat4 l_rigMatrix = mat4(1.f);
    if(gAnimated == true)
    {
        l_rigMatrix = gBoneMatrix[gVertexBoneIndex.x]*gVertexBoneWeight.x;
        l_rigMatrix += gBoneMatrix[gVertexBoneIndex.y]*gVertexBoneWeight.y;
        l_rigMatrix += gBoneMatrix[gVertexBoneIndex.z]*gVertexBoneWeight.z;
        l_rigMatrix += gBoneMatrix[gVertexBoneIndex.w]*gVertexBoneWeight.w;
    }
    tUV = gVertexUV;
    tNormal = normalize((gModelMatrix*l_rigMatrix*vec4(gVertexNormal,0.0)).xyz);
    tShadowCoord = gShadowViewProjectionMatrix*gModelMatrix*l_rigMatrix*l_vertexPosition;
    gl_Position = gViewProjectionMatrix*gModelMatrix*l_rigMatrix*l_vertexPosition;
}