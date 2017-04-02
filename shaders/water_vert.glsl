#version 330 core
//Default variables
layout(location = 0) in vec3 gVertexPosition;
layout(location = 1) in vec2 gVertexUV;
layout(location = 2) in vec3 gVertexNormal;

out vec2 tUV;
out vec3 tVertexPosition;

//Default variables
uniform mat4 gProjectionMatrix;
uniform mat4 gViewMatrix;
uniform mat4 gModelMatrix;
uniform float gTime;

void main()
{
    tUV = gVertexUV;
    vec3 l_vertexPosition = gVertexPosition;
    l_vertexPosition.y += sin(l_vertexPosition.x+gTime)*cos(l_vertexPosition.z+gTime)*0.25f;
    tVertexPosition = (gModelMatrix*vec4(l_vertexPosition,1.f)).xyz;
    gl_Position = gProjectionMatrix*gViewMatrix*gModelMatrix*vec4(l_vertexPosition,1.0);
}