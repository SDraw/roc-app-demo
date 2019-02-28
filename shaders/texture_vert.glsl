layout(location = 0) in vec3 gVertexPosition;
layout(location = 2) in vec2 gVertexUV;

out vec2 tUV;

uniform mat4 gModelMatrix;
uniform mat4 gProjectionMatrix;

void main()
{
    tUV = gVertexUV;
    gl_Position = gProjectionMatrix*gModelMatrix*vec4(gVertexPosition,1.0);
}  