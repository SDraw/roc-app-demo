#version 330 core
//Default variables
layout(location = 0) in vec3 gVertexPosition;

//Output
out vec3 tSkyPosition;

//Default variables
uniform mat4 gViewProjectionMatrix;
uniform mat4 gModelMatrix;

void main()
{
    vec4 l_vertexPosition = vec4(gVertexPosition,1.0);
    tSkyPosition = (gModelMatrix*l_vertexPosition).xyz;
    gl_Position = gViewProjectionMatrix*gModelMatrix*l_vertexPosition;
}