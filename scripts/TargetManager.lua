TargetManager = {}
TargetManager.__index = TargetManager

function TargetManager.init()
    local self = TargetManager
    
    self.ms_cache = {
        shadow = RenderTarget(1024,1024,0,"depth","linear")
    }
end
addEventHandler("onEngineStart",TargetManager.init)

function TargetManager:getCached(str1)
    return self.ms_cache[str1]
end

TargetManager = setmetatable({},TargetManager)
