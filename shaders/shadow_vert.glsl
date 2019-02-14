#version 330 core
layout(location = 0) in vec3 gVertexPosition;
layout(location = 3) in vec4 gVertexBoneWeight;
layout(location = 4) in ivec4 gVertexBoneIndex;

uniform mat4 gViewProjectionMatrix;
uniform mat4 gModelMatrix;
uniform bool gAnimated;
uniform mat4 gBoneMatrix[128];

void main()
{
    mat4 l_rigMatrix = mat4(1.f);
    if(gAnimated == true)
    {
        l_rigMatrix = gBoneMatrix[gVertexBoneIndex.x]*gVertexBoneWeight.x;
        l_rigMatrix += gBoneMatrix[gVertexBoneIndex.y]*gVertexBoneWeight.y;
        l_rigMatrix += gBoneMatrix[gVertexBoneIndex.z]*gVertexBoneWeight.z;
        l_rigMatrix += gBoneMatrix[gVertexBoneIndex.w]*gVertexBoneWeight.w;
    }
    gl_Position = gViewProjectionMatrix*gModelMatrix*l_rigMatrix*vec4(gVertexPosition,1.0);
}