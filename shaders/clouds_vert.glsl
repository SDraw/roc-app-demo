#version 330 core
//Default variables
layout(location = 0) in vec3 gVertexPosition;
layout(location = 1) in vec2 gVertexUV;

out vec2 tUV;
out vec3 tCloudsPosition;

//Default variables
uniform mat4 gProjectionMatrix;
uniform mat4 gViewMatrix;
uniform mat4 gModelMatrix;

void main()
{
    vec4 l_vertexPosition = vec4(gVertexPosition,1.0);
    tUV = gVertexUV;
    tCloudsPosition = (gViewMatrix*gModelMatrix*l_vertexPosition).xyz;
    gl_Position = gProjectionMatrix*gViewMatrix*gModelMatrix*l_vertexPosition;
}