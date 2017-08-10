#version 330 core
in vec2 tUV;
out vec4 gOutput;

uniform sampler2D gTexture0;
uniform vec4 gColor;

void main()
{
    gOutput = texture(gTexture0,tUV)*gColor;
}