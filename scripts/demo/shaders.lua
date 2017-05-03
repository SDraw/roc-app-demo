shader = {}

function shader.init()
    shader.main = {}
    shader.main.element = shaderCreate("shaders/main_vert.glsl","shaders/main_frag.glsl")
    shaderSetUniformValue(shader.main.element,"gTexture3","drawable",target.shadow)
    shaderSetUniformValue(shader.main.element,"gShadowSamples","float",1.0)
    
    shader.skybox = shaderCreate("shaders/skybox_vert.glsl","shaders/skybox_frag.glsl")
    shader.clouds = shaderCreate("shaders/clouds_vert.glsl","shaders/clouds_frag.glsl")
    shader.shadow = shaderCreate("shaders/shadow_vert.glsl","shaders/shadow_frag.glsl")
    shader.text = shaderCreate("shaders/text_vert.glsl","shaders/text_frag.glsl")
    shader.texture = shaderCreate("shaders/texture_vert.glsl","shaders/texture_frag.glsl")
    shader.fire = shaderCreate("shaders/fire_vert.glsl","shaders/fire_frag.glsl")
end
addEventHandler("onAppStart",shader.init)

function shader.getShadowShader()
    return shader.shadow
end

function shader.getMainShader()
    return shader.main.element
end
function shader.updateMainShadowProjection(table1)
    shaderSetUniformValue(shader.main.element,"gShadowProjectionMatrix","mat4",table1)
end
function shader.updateMainShadowView(table1)
    shaderSetUniformValue(shader.main.element,"gShadowViewMatrix","mat4",table1)
end
function shader.setShadowSamples(val1)
    shaderSetUniformValue(shader.main.element,"gShadowSamples","float",val1)
end

function shader.getFontShader()
    return shader.text
end

function shader.getTextureShader()
    return shader.texture
end

function shader.getSkyboxShader()
    return shader.skybox
end
function shader.getCloudsShader()
    return shader.clouds
end
function shader.getFireShader()
    return shader.fire
end