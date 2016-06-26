data.shader = {}

data.shader["shadow"] = shaderCreate("shaders/shadow_vert.txt","shaders/shadow_frag.txt")

data.shader["default"] = {}
data.shader["default"].element = shaderCreate("shaders/diffuse_vert.txt","shaders/irradiance_frag.txt")
local l_value = shaderGetUniform(data.shader["default"].element,"gTexture3")
shaderSetUniformValue(data.shader["default"].element,l_value,"int",3)
data.shader["default"].shadowViewMatrixUniform = shaderGetUniform(data.shader["default"].element,"gShadowViewMatrix")
data.shader["default"].shadowProjectionMatrixUniform = shaderGetUniform(data.shader["default"].element,"gShadowProjectionMatrix")
data.shader["default"].shadowSamplesUniform = shaderGetUniform(data.shader["default"].element,"gShadowSamples")
print(type(data.shader["default"].shadowSamplesUniform))
shaderSetUniformValue(data.shader["default"].element,data.shader["default"].shadowSamplesUniform,"float",2.0)
local l_value = shaderGetUniform(data.shader["default"].element,"gTexture5")
shaderSetUniformValue(data.shader["default"].element,l_value,"int",5)

shaderSetUniformValue(data.shader["default"].element,data.shader["default"].shadowViewMatrixUniform,"mat4",cameraGetViewMatrix(data.scene["shadow"].camera))
shaderSetUniformValue(data.shader["default"].element,data.shader["default"].shadowProjectionMatrixUniform,"mat4",cameraGetProjectionMatrix(data.scene["shadow"].camera))

data.shader["text"] = {}
data.shader["text"].element = shaderCreate("shaders/text_vert.txt","shaders/text_frag.txt")

data.shader["cloud"] = shaderCreate("shaders/cloud_vert.txt","shaders/cloud_frag.txt")

data.shader["texture"] = shaderCreate("shaders/texture_vert.txt","shaders/texture_frag.txt")