#version 330 core
in vec3 tColor;
out vec4 gOutput;

void main()
{
    gOutput = vec4(tColor,1.f);
}