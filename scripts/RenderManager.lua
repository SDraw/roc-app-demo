RenderManager = {}
RenderManager.__index = RenderManager

function RenderManager.init()
    local self = RenderManager
    
    self.ms_fps = 60
    self.ms_time = getTime()
    
    self.ms_queue = {
        shadow = {},
        skybox = {},
        main = {},
        gui = {}
    }
    
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
    SceneManager:setActive("shadow")
    clearRenderArea()
    for _,v in ipairs(self.ms_queue.shadow) do
        v:draw(false)
    end
    
    -- Skybox pass
    SceneManager:setActive("skybox")
    clearRenderArea()
    for _,v in ipairs(self.ms_queue.skybox) do
        v:draw()
    end
    
    -- Main pass
    SceneManager:setActive("main")
    clearRenderArea(true,false)
    for _,v in ipairs(self.ms_queue.main) do
        v:draw()
    end
    
    -- GUI pass
    for _,v in ipairs(self.ms_queue.gui) do
        v()
    end
end

function RenderManager:addToQueue(str1,var1)
    if(self.ms_queue[str1]) then
        if(type(var1) == "table") then
            for _,v in pairs(var1) do
                if(type(v) ~= "table") then
                    table.insert(self.ms_queue[str1],v)
                end
            end
        else
            table.insert(self.ms_queue[str1],var1)
        end
    end
end

function RenderManager:removeFromQueue(str1,var1)
    if(self.ms_queue[str1]) then
        if(type(var1) == "table") then
            for _,v in pairs(var1) do
                if(type(v) ~= "table") then
                    for kk,vv in ipairs(self.ms_queue[str1]) do
                        if(v == vv) then
                            table.remove(self.ms_queue[str1],kk)
                            break
                        end
                    end
                end
            end
        else
            for k,v in ipairs(self.ms_queue[str1]) do
                if(v == var1) then
                    table.remove(self.ms_queue[str1],kk)
                    break
                end
            end
        end
    end
end

RenderManager = setmetatable({},RenderManager)
