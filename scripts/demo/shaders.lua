data.shader = {}

data.shader.shadow = shaderCreate("shaders/shadow_vert.txt","shaders/shadow_frag.txt")

data.shader.default = {}
data.shader.default.element = shaderCreate("shaders/diffuse_vert.txt","shaders/irradiance_frag.txt")
data.shader.default.shadowTextureUniform = shaderGetUniform(data.shader.default.element,"gTexture3")
shaderSetUniformValue(data.shader.default.element,data.shader.default.shadowTextureUniform,"target",data.target.shadow)

data.shader.default.irradianceUniform = shaderGetUniform(data.shader.default.element,"gTexture5")
shaderSetUniformValue(data.shader.default.element,data.shader.default.irradianceUniform,"texture",data.texture.irradiance)

data.shader.default.shadowViewMatrixUniform = shaderGetUniform(data.shader.default.element,"gShadowViewMatrix")
shaderSetUniformValue(data.shader.default.element,data.shader.default.shadowViewMatrixUniform,"mat4",cameraGetViewMatrix(data.scene.shadow.camera))

data.shader.default.shadowProjectionMatrixUniform = shaderGetUniform(data.shader.default.element,"gShadowProjectionMatrix")
shaderSetUniformValue(data.shader.default.element,data.shader.default.shadowProjectionMatrixUniform,"mat4",cameraGetProjectionMatrix(data.scene.shadow.camera))

data.shader.default.shadowSamplesUniform = shaderGetUniform(data.shader.default.element,"gShadowSamples")
shaderSetUniformValue(data.shader.default.element,data.shader.default.shadowSamplesUniform,"float",2.0)

data.shader.text = shaderCreate("shaders/text_vert.txt","shaders/text_frag.txt")

data.shader.cloud = shaderCreate("shaders/cloud_vert.txt","shaders/cloud_frag.txt")

data.shader.texture = shaderCreate("shaders/texture_vert.txt","shaders/texture_frag.txt")

