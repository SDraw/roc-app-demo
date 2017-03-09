data.shader = {}

data.shader.shadow = shaderCreate("shaders/shadow_vert.glsl","shaders/shadow_frag.glsl")

data.shader.default = {}
data.shader.default.element = shaderCreate("shaders/diffuse_vert.glsl","shaders/irradiance_frag.glsl")
data.shader.default.shadowTextureUniform = shaderGetUniform(data.shader.default.element,"gTexture3")
shaderSetUniformValue(data.shader.default.element,data.shader.default.shadowTextureUniform,"drawable",data.target.shadow)

data.shader.default.irradianceUniform = shaderGetUniform(data.shader.default.element,"gTexture5")
shaderSetUniformValue(data.shader.default.element,data.shader.default.irradianceUniform,"drawable",data.texture.irradiance)

data.shader.default.shadowViewMatrixUniform = shaderGetUniform(data.shader.default.element,"gShadowViewMatrix")
shaderSetUniformValue(data.shader.default.element,data.shader.default.shadowViewMatrixUniform,"mat4",cameraGetViewMatrix(data.scene.shadow.camera))

data.shader.default.shadowProjectionMatrixUniform = shaderGetUniform(data.shader.default.element,"gShadowProjectionMatrix")
shaderSetUniformValue(data.shader.default.element,data.shader.default.shadowProjectionMatrixUniform,"mat4",cameraGetProjectionMatrix(data.scene.shadow.camera))

data.shader.default.shadowSamplesUniform = shaderGetUniform(data.shader.default.element,"gShadowSamples")
shaderSetUniformValue(data.shader.default.element,data.shader.default.shadowSamplesUniform,"float",2.0)

data.shader.text = shaderCreate("shaders/text_vert.glsl","shaders/text_frag.glsl")
data.shader.texture = shaderCreate("shaders/texture_vert.glsl","shaders/texture_frag.glsl")
