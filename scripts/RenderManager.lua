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
    clearRenderArea()
    SceneManager:draw("shadow")
    
    -- Main pass
    SceneManager:update_S2()
    SceneManager:setActive("main")
    clearRenderArea()
    SceneManager:draw("main")
    
    if(PhysicsManager:getDebugDraw()) then
        if(PhysicsManager:getDebugDrawMode() == "xray") then
            clearRenderArea(true,false)
        end
        drawPhysics()
    end
    
    -- GUI pass, 'main' scene
    clearRenderArea(true,false)
    GuiManager:draw()
end

RenderManager = setmetatable({},RenderManager)