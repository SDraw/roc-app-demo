#version 330 core

out float gOutput;

void main() 
{
    gOutput = gl_FragCoord.z;
}