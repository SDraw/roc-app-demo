PhysicsManager = {}
PhysicsManager.__index = PhysicsManager

function PhysicsManager.init()
    local self = PhysicsManager
    
    self.ms_drawDebug = false
    self.ms_drawMode = "normal"
    
    physicsSetFloorEnabled(true)
    physicsSetEnabled(true)
    
    addEventHandler("onKeyPress",self.onKeyPress_state)
    addEventHandler("onKeyPress",self.onKeyPress_chaos)
    addEventHandler("onKeyPress",self.onKeyPress_debug)
end
addEventHandler("onEngineStart",PhysicsManager.init)

function PhysicsManager:getDebugDraw()
    return self.ms_drawDebug
end
function PhysicsManager:getDebugDrawMode()
    return self.ms_drawMode
end

function PhysicsManager.onKeyPress_state(str1,val1)
    if(str1 == 'n' and val1 == 1) then
        physicsSetEnabled(not physicsGetEnabled())
    end
end

function PhysicsManager.onKeyPress_chaos(str1,val1)
    if(str1 == 'j' and val1 == 1) then
        local l_gx,l_gy,l_gz = physicsGetGravity()
        physicsSetGravity(l_gx,-l_gy,l_gz)
    end
end

function PhysicsManager.onKeyPress_debug(str1,val1)
    local self = PhysicsManager
    if(str1 == "f1" and val1 == 1) then
        self.ms_drawDebug = not self.ms_drawDebug
    elseif(str1 == "f2" and val1 == 1 and self.ms_drawDebug) then
        self.ms_drawMode = ((self.ms_drawMode == "normal") and "xray" or "normal")
    end
end

PhysicsManager = setmetatable({},PhysicsManager)
