in vec3 tPosition;
out vec4 gOutput;

// Default uniforms
uniform vec3 gCameraPosition;

// Custom uniforms
uniform vec3 gSkyGradientDown;
uniform vec3 gSkyGradientUp;

void main() 
{
    vec3 l_normal = normalize(tPosition-gCameraPosition);
    vec3 l_skyColor = mix(gSkyGradientDown,gSkyGradientUp,l_normal.y*0.5f+0.5f);
    gOutput = vec4(l_skyColor,1.f);
}