SceneManager = {}
SceneManager.__index = SceneManager

function SceneManager.init()
    local self = SceneManager
    
    self.ms_cache = {
        shadow = {
            m_scene = Scene(),
            m_lights = {},
            m_camera = Camera("orthogonal"),
            m_shader = Shader("shaders/shadow_vert.glsl","shaders/shadow_frag.glsl"),
            m_target = RenderTarget("shadow",1024,1024,"linear")
        },
        skybox = {
            m_scene = Scene(),
            m_lights = {},
            m_camera = false,
            m_shader = Shader("shaders/skybox_vert.glsl","shaders/skybox_frag.glsl"),
            m_target = false
        },
        main = {
            m_scene = Scene(),
            m_lights =
            {
                Light("directional"), -- main light
                Light("point"),
                Light("point"),
                Light("spotlight")
            },
            m_camera = Camera("perspective"),
            m_shader = Shader("shaders/main_vert.glsl","shaders/main_frag.glsl"),
            m_target = false
        },
        physics = {
            m_scene = Scene(),
            m_lights = {},
            m_camera = false,
            m_shader = Shader("shaders/physics_vert.glsl","shaders/physics_frag.glsl"),
            m_target = false
        },
        screen = {
            m_scene = Scene(),
            m_lights = {},
            m_camera = false,
            m_shader = Shader("shaders/texture_vert.glsl","shaders/texture_frag.glsl"),
            m_target = false
        }
    }
    
    -- Shadow
    self.ms_cache.shadow.m_camera:setPosition(0.0,0.0,0.0)
    self.ms_cache.shadow.m_camera:setDirection(-0.707106,-0.707106,0.0)
    self.ms_cache.shadow.m_camera:setOrthoParams(-32.0,32.0,-32.0,32.0)
    self.ms_cache.shadow.m_camera:setDepth(-50.0,50.0)
    self.ms_cache.shadow.m_target:setProperty("color",false)
    self.ms_cache.shadow.m_scene:setCamera(self.ms_cache.shadow.m_camera)
    self.ms_cache.shadow.m_scene:setRenderTarget(self.ms_cache.shadow.m_target)
    self.ms_cache.shadow.m_scene:setShader(self.ms_cache.shadow.m_shader)
    
    -- Skybox
    self.ms_cache.skybox.m_scene:setCamera(self.ms_cache.main.m_camera)
    self.ms_cache.skybox.m_scene:setShader(self.ms_cache.skybox.m_shader)
    self.ms_cache.skybox.m_shader:setUniformValue("gSkyGradientDown", "float3", 0.73791,0.73791,0.73791)
    self.ms_cache.skybox.m_shader:setUniformValue("gSkyGradientUp", "float3", 0.449218,0.710937,1.0)
    
    -- Main
    self.ms_cache.main.m_lights[1]:setColor(1.0,1.0,1.0, 1.0)
    self.ms_cache.main.m_lights[1]:setDirection(-0.707106,-0.707106,0.0)
    
    self.ms_cache.main.m_lights[2]:setFalloff(0,0,0.125)
    self.ms_cache.main.m_lights[2]:setColor(0.5,0.25,1.0, 0.75)
    self.ms_cache.main.m_lights[2]:setPosition(0,5.0,0.0)
    
    self.ms_cache.main.m_lights[3]:setFalloff(0,0,0.125)
    self.ms_cache.main.m_lights[3]:setColor(0.25,0.5,1.0, 0.75)
    self.ms_cache.main.m_lights[3]:setPosition(0,5.0,0.0)
    
    self.ms_cache.main.m_lights[4]:setFalloff(1.0, 0.045, 0.0075)
    self.ms_cache.main.m_lights[4]:setCutoff(0.75,0.6)
    self.ms_cache.main.m_lights[4]:setColor(1,0,0, 1)
    self.ms_cache.main.m_lights[4]:setPosition(0,7.5,0.0)
    self.ms_cache.main.m_lights[4]:setDirection(0,-1.0,0.0)
    
    self.ms_cache.main.m_camera:setPosition(0,5,-5)
    self.ms_cache.main.m_camera:setDepth(0.2,300.0)
    self.ms_cache.main.m_camera:setFOV(math.pi/4)
    local l_windowSize = { getWindowSize() }
    self.ms_cache.main.m_camera:setAspectRatio(l_windowSize[1]/l_windowSize[2])
    
    for _,v in ipairs(self.ms_cache.main.m_lights) do
        self.ms_cache.main.m_scene:addLight(v)
    end
    self.ms_cache.main.m_scene:setCamera(self.ms_cache.main.m_camera)
    
    self.ms_cache.main.m_scene:setShader(self.ms_cache.main.m_shader)
    self.ms_cache.main.m_shader:attach(self.ms_cache.shadow.m_target,"gTexture3")
    self.ms_cache.main.m_shader:setUniformValue("gSkyGradientDown", "float3", 0.73791,0.73791,0.73791)
    self.ms_cache.main.m_shader:setUniformValue("gSkyGradientUp", "float3", 0.449218,0.710937,1.0)
    
    -- Physics
    self.ms_cache.physics.m_scene:setCamera(self.ms_cache.main.m_camera)
    self.ms_cache.physics.m_scene:setShader(self.ms_cache.physics.m_shader)
    
    -- Screen
    self.ms_cache.screen.m_scene:setShader(self.ms_cache.screen.m_shader)
    
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
    end
end
function SceneManager:draw(str1)
    local l_sceneData = self.ms_cache[str1]
    if(l_sceneData) then
        l_sceneData.m_scene:draw()
    end
end

function SceneManager:addModelToScene(str1,ud1,str2)
    local l_sceneData = self.ms_cache[str1]
    if(l_sceneData) then
        l_sceneData.m_scene:addModel(ud1,str2)
    end
end

function SceneManager:getCamera(str1)
    return (self.ms_cache[str1] and self.ms_cache[str1].m_camera or false)
end

function SceneManager:getLights(str1)
    return (self.ms_cache[str1] and self.ms_cache[str1].m_lights or false)
end

function SceneManager:update_S1()
    self.ms_cache.shadow.m_camera:setPosition(self.ms_cache.main.m_camera:getPosition())
end
function SceneManager:update_S2()
    self.ms_cache.main.m_shader:setUniformValue("gShadowViewProjectionMatrix", "mat4", self.ms_cache.shadow.m_camera:getViewProjectionMatrix())
end

SceneManager = setmetatable({},SceneManager)
