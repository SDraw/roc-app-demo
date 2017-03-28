data.shader = {}

data.shader.shadow = shaderCreate("shaders/shadow_vert.glsl","shaders/shadow_frag.glsl")

data.shader.default = {}
data.shader.default.element = shaderCreate("shaders/diffuse_vert.glsl","shaders/irradiance_frag.glsl")
shaderSetUniformValue(data.shader.default.element,"gTexture3","drawable",data.target.shadow)
shaderSetUniformValue(data.shader.default.element,"gTexture5","drawable",data.texture.irradiance)

shaderSetUniformValue(data.shader.default.element,"gShadowViewMatrix","mat4",cameraGetViewMatrix(data.scene.shadow.camera))
shaderSetUniformValue(data.shader.default.element,"gShadowProjectionMatrix","mat4",cameraGetProjectionMatrix(data.scene.shadow.camera))
shaderSetUniformValue(data.shader.default.element,"gShadowSamples","float",1.0)

data.shader.text = shaderCreate("shaders/text_vert.glsl","shaders/text_frag.glsl")
data.shader.texture = shaderCreate("shaders/texture_vert.glsl","shaders/texture_frag.glsl")
