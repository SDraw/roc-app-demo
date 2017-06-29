shader = {}

function shader.init()
    shader.main = {}
    shader.main.element = Shader("shaders/main_vert.glsl","shaders/main_frag.glsl")
    shader.main.element:setUniformValue("gShadowSamples","float",1.0)
    shader.main.element:attach(target.shadow,"gTexture3")
    
    shader.skybox = Shader("shaders/skybox_vert.glsl","shaders/skybox_frag.glsl")
    shader.clouds = Shader("shaders/clouds_vert.glsl","shaders/clouds_frag.glsl")
    shader.shadow = Shader("shaders/shadow_vert.glsl","shaders/shadow_frag.glsl")
    shader.text = Shader("shaders/text_vert.glsl","shaders/text_frag.glsl")
    shader.texture = Shader("shaders/texture_vert.glsl","shaders/texture_frag.glsl")
    shader.fire = Shader("shaders/fire_vert.glsl","shaders/fire_frag.glsl")
end
addEventHandler("onEngineStart",shader.init)

function shader.getShadowShader()
    return shader.shadow
end

function shader.getMainShader()
    return shader.main.element
end
function shader.updateMainShadowProjection(table1)
    shader.main.element:setUniformValue("gShadowProjectionMatrix","mat4",table1)
end
function shader.updateMainShadowView(table1)
    shader.main.element:setUniformValue("gShadowViewMatrix","mat4",table1)
end
function shader.setShadowSamples(val1)
    shader.main.element:setUniformValue("gShadowSamples","float",val1)
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