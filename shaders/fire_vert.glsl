#version 330 core
//Default variables
layout(location = 0) in vec3 gVertexPosition;
layout(location = 1) in vec2 gVertexUV;

out vec2 tUV;

//Default variables
uniform mat4 gProjectionMatrix;
uniform mat4 gViewMatrix;
uniform mat4 gModelMatrix;

void main()
{
    tUV = gVertexUV;
    gl_Position = gProjectionMatrix*gViewMatrix*gModelMatrix*vec4(gVertexPosition,1.0);
}