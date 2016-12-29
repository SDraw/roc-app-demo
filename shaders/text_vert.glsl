#version 330 core
layout(location = 0) in vec3 gVertexPosition;
layout(location = 1) in vec2 gVertexUV;

out vec2 tUV;

uniform mat4 gProjectionMatrix;

void main()
{
 tUV = gVertexUV;
 gl_Position = gProjectionMatrix*vec4(gVertexPosition,1.0);
}  