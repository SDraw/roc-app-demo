SceneManager = {}
SceneManager.__index = SceneManager

function SceneManager.init()
    local self = SceneManager
    
    self.ms_cache = {
        shadow = {
            m_scene = Scene(),
            m_light = false,
            m_camera = Camera("orthogonal"),
            m_shader = Shader("shaders/shadow_vert.glsl","shaders/shadow_frag.glsl"),
            m_target = RenderTarget("shadow",1024,1024,"linear")
        },
        skybox = {
            m_scene = Scene(),
            m_light = false,
            m_camera = false,
            m_shader = Shader("shaders/skybox_vert.glsl","shaders/skybox_frag.glsl"),
            m_target = false
        },
        main = {
            m_scene = Scene(),
            m_light = Light(),
            m_camera = Camera("perspective"),
            m_shader = Shader("shaders/main_vert.glsl","shaders/main_frag.glsl"),
            m_target = false
        },
        physics = {
            m_scene = Scene(),
            m_light = false,
            m_camera = false,
            m_shader = Shader("shaders/physics_vert.glsl","shaders/physics_frag.glsl"),
            m_target = false
        }
    }
    
    self.ms_cache.shadow.m_camera:setPosition(0.0,0.0,0.0)
    self.ms_cache.shadow.m_camera:setDirection(-0.707106,-0.707106,0.0)
    self.ms_cache.shadow.m_camera:setOrthoParams(-32.0,32.0,-32.0,32.0)
    self.ms_cache.shadow.m_camera:setDepth(-50.0,50.0)
    self.ms_cache.shadow.m_scene:setCamera(self.ms_cache.shadow.m_camera)
    self.ms_cache.shadow.m_scene:setRenderTarget(self.ms_cache.shadow.m_target)
    self.ms_cache.shadow.m_scene:setShader(self.ms_cache.shadow.m_shader)
    
    self.ms_cache.main.m_light:setParams(0.5,1.0,0.5,16.0)
    self.ms_cache.main.m_light:setColor(1.0,1.0,1.0)
    self.ms_cache.main.m_light:setDirection(-0.707106,-0.707106,0.0)
    
    self.ms_cache.main.m_camera:setPosition(0,5,-5)
    self.ms_cache.main.m_camera:setDepth(0.2,300.0)
    self.ms_cache.main.m_camera:setFOV(math.pi/4)
    local l_windowSize = { getWindowSize() }
    self.ms_cache.main.m_camera:setAspectRatio(l_windowSize[1]/l_windowSize[2])
    
    self.ms_cache.main.m_scene:setLight(self.ms_cache.main.m_light)
    self.ms_cache.main.m_scene:setCamera(self.ms_cache.main.m_camera)
    self.ms_cache.main.m_scene:setShader(self.ms_cache.main.m_shader)
    self.ms_cache.main.m_scene:setSkyGradient(0.73791,0.73791,0.73791, 0.449218,0.710937,1.0)
    self.ms_cache.main.m_shader:attach(self.ms_cache.shadow.m_target,"gTexture3")
    
    self.ms_cache.skybox.m_scene:setCamera(self.ms_cache.main.m_camera)
    self.ms_cache.skybox.m_scene:setLight(self.ms_cache.main.m_light)
    self.ms_cache.skybox.m_scene:setShader(self.ms_cache.skybox.m_shader)
    self.ms_cache.skybox.m_scene:setSkyGradient(0.73791,0.73791,0.73791, 0.449218,0.710937,1.0)
    
    self.ms_cache.physics.m_scene:setCamera(self.ms_cache.main.m_camera)
    self.ms_cache.physics.m_scene:setShader(self.ms_cache.physics.m_shader)
    
    addEventHandler("onWindowResize",self.onWindowResize)
end
addEventHandler("onEngineStart",SceneManager.init)

function SceneManager.onWindowResize(val1,val2)
    local self = SceneManager
    self.ms_cache.main.m_camera:setAspectRatio(val1/val2)
end

function SceneManager:setActive(str1)
    local l_sceneData = self.ms_cache[str1]
    if(l_sceneData) then
        l_sceneData.m_scene:setActive()
        l_sceneData.m_scene:draw()
    end
end
function SceneManager:draw(str1)
    local l_sceneData = self.ms_cache[str1]
    if(l_sceneData) then
        l_sceneData.m_scene:draw()
    end
end

function SceneManager:addModelToScene(str1,ud1)
    local l_sceneData = self.ms_cache[str1]
    if(l_sceneData) then
        l_sceneData.m_scene:addModel(ud1)
    end
end

function SceneManager:getCamera(str1)
    return (self.ms_cache[str1] and self.ms_cache[str1].m_camera or false)
end

function SceneManager:update_S1()
    self.ms_cache.shadow.m_camera:setPosition(self.ms_cache.main.m_camera:getPosition())
end
function SceneManager:update_S2()
    self.ms_cache.main.m_shader:setUniformValue("gShadowViewProjectionMatrix",self.ms_cache.shadow.m_camera:getViewProjectionMatrix())
end

SceneManager = setmetatable({},SceneManager)
