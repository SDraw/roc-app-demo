#version 330 core
//Default variables
layout(location = 0) in vec3 gVertexPosition;
layout(location = 2) in vec3 gVertexNormal;

//Output
out vec3 tColor;

//Default variables
uniform mat4 gViewProjectionMatrix;
uniform mat4 gModelMatrix;

void main()
{
    tColor = gVertexNormal;
    gl_Position = gViewProjectionMatrix*gModelMatrix*vec4(gVertexPosition,1.0);
}