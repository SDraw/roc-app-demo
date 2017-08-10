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
            m_target = TargetManager:getCached("shadow")
        },
        skybox = {
            m_scene = Scene(),
            m_light = false,
            m_camera = false,
            m_shader = Shader("shaders/skybox_vert.glsl","shaders/skybox_frag.glsl")
        },
        main = {
            m_scene = Scene(),
            m_light = Light(),
            m_camera = Camera("perspective"),
            m_shader = Shader("shaders/main_vert.glsl","shaders/main_frag.glsl")
        }
    }
    
    self.ms_cache.shadow.m_camera:setPosition(0.0,0.0,0.0)
    self.ms_cache.shadow.m_camera:setDirection(-0.707106,-0.707106,0.0)
    self.ms_cache.shadow.m_camera:setOrthoParams(-32.0,32.0,-32.0,32.0)
    self.ms_cache.shadow.m_camera:setDepth(-50.0,50.0)
    self.ms_cache.shadow.m_scene:setCamera(self.ms_cache.shadow.m_camera)
    
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
    self.ms_cache.main.m_shader:attach(self.ms_cache.shadow.m_target,"gTexture3")
    
    self.ms_cache.skybox.m_scene:setCamera(self.ms_cache.main.m_camera)
    self.ms_cache.skybox.m_scene:setLight(self.ms_cache.main.m_light)
    
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
        setRenderTarget(l_sceneData.m_target and l_sceneData.m_target or nil)
        setActiveShader(l_sceneData.m_shader)
        setActiveScene(l_sceneData.m_scene)
        
        if(str1 == "main") then
            l_sceneData.m_shader:setUniformValue("gShadowViewProjectionMatrix","mat4",self.ms_cache.shadow.m_camera:getViewProjectionMatrix())
        end
    end
end

function SceneManager:getCamera(str1)
    return (self.ms_cache[str1] and self.ms_cache[str1].m_camera or false)
end

SceneManager = setmetatable({},SceneManager)
