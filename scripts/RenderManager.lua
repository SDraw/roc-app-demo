RenderManager = {}
RenderManager.__index = RenderManager

function RenderManager.init()
    local self = RenderManager
    
    self.ms_fps = 60
    self.ms_time = getTime()
    
    addEventHandler("onRender",self.onRender)
end
addEventHandler("onEngineStart",RenderManager.init)

function RenderManager:getFPS()
    return self.ms_fps
end

function RenderManager.onRender()
    local self = RenderManager
    
    -- Update FPS and time
    local l_time = getTime()
    self.ms_fps = 1.0/(l_time-self.ms_time)
    self.ms_time = l_time
    
    -- Shadow pass
    SceneManager:update_S1()
    SceneManager:setActive("shadow")
    SceneManager:draw("shadow")
    
    -- Skybox pass
    SceneManager:setActive("skybox")
    SceneManager:draw("skybox")
    
    -- Main pass
    SceneManager:setActive("main")
    SceneManager:update_S2()
    SceneManager:draw("main")
    
    if(PhysicsManager:getDebugDraw()) then
        SceneManager:setActive("physics")
        if(PhysicsManager:getDebugDrawMode() == "xray") then
            clearViewport(true,false)
        end
        drawPhysics()
    end
    
    -- GUI pass
    SceneManager:setActive("screen")
    GuiManager:draw()
end

RenderManager = setmetatable({},RenderManager)