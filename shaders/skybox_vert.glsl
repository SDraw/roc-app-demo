#version 330 core
//Default variables
layout(location = 0) in vec3 gVertexPosition;

//Output
out vec3 tSkyPosition;

//Default variables
uniform mat4 gProjectionMatrix;
uniform mat4 gViewMatrix;
uniform mat4 gModelMatrix;

void main()
{
    tSkyPosition = (gModelMatrix*vec4(gVertexPosition,1.0)).xyz;
    gl_Position = gProjectionMatrix*gViewMatrix*gModelMatrix*vec4(gVertexPosition,1.0);
}