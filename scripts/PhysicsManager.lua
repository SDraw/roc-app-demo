PhysicsManager = {}
PhysicsManager.__index = PhysicsManager

function PhysicsManager.init()
    local self = PhysicsManager
    
    self.ms_debug = false
    
    physicsSetFloorEnabled(true)
    physicsSetEnabled(true)
    
    addEventHandler("onKeyPress",self.onKeyPress_state)
    addEventHandler("onKeyPress",self.onKeyPress_chaos)
    addEventHandler("onKeyPress",self.onKeyPress_debug)
end
addEventHandler("onEngineStart",PhysicsManager.init)

function PhysicsManager:isDebugEnabled()
    return self.ms_debug
end

function PhysicsManager.onKeyPress_state(str1,val1)
    if(str1 == '1' and val1 == 1) then
        physicsSetEnabled(not physicsGetEnabled())
    end
end

function PhysicsManager.onKeyPress_chaos(str1,val1)
    if(str1 == '2' and val1 == 1) then
        for _,v in ipairs(WorldManager:getModel("rigid")) do
            local l_col = v:getCollision()
            local l_vx,l_vy,l_vz = l_col:getVelocity()
            l_vx = l_vx+math.random()*9.8*(math.random() <= 0.5 and -1 or 1)
            l_vy = l_vy+math.random()*9.8*(math.random() <= 0.5 and -1 or 1)
            l_vz = l_vz+math.random()*9.8*(math.random() <= 0.5 and -1 or 1)
            l_col:setVelocity(l_vx,l_vy,l_vz)
        end
    end
end

function PhysicsManager.onKeyPress_debug(str1,val1)
    local self = PhysicsManager
    if(str1 == '3' and val1 == 1) then
        self.ms_debug = not self.ms_debug
    end
end

PhysicsManager = setmetatable({},PhysicsManager)
