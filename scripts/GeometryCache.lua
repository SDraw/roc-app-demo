GeometryCache = {}
GeometryCache.__index = GeometryCache

addEvent("onGeometryCacheLoad")
function GeometryCache.init()
    local self = GeometryCache
    
    self.ms_tasks = {
        [Geometry("models/skybox.rmf",self.onGeometryLoad)] = {
            name = "skybox"
        },
        [Geometry("models/plane.rmf",self.onGeometryLoad)] = {
            name = "plane"
        },
        [Geometry("models/cube.rmf",self.onGeometryLoad)] = {
            name = "cube"
        },
        [Geometry("models/cone.rmf",self.onGeometryLoad)] = {
            name = "cone"
        },
        [Geometry("models/cylinder.rmf",self.onGeometryLoad)] = {
            name = "cylinder"
        },
        [Geometry("models/icosphere.rmf",self.onGeometryLoad)] = {
            name = "sphere"
        },
        [Geometry("models/dummy.rmf",self.onGeometryLoad)] = {
            name = "dummy"
        }
    }
    self.ms_tasksCount = 0
    for k,v in pairs(self.ms_tasks) do
        self.ms_tasksCount = self.ms_tasksCount+1
    end
    self.ms_tasksResult = 0
    
    self.ms_cache = {}
end
addEventHandler("onEngineStart",GeometryCache.init)

function GeometryCache.onGeometryLoad(ud1,ud2)
    local self = GeometryCache
    
    if(self.ms_tasks[ud1]) then
        if(ud2) then
            self.ms_cache[self.ms_tasks[ud1].name] = ud2
            
            self.ms_tasksResult = self.ms_tasksResult+1
            if(self.ms_tasksResult == self.ms_tasksCount) then
                callEvent("onGeometryCacheLoad")
            end
        else
            logPrint("Unable to load geometry for '"..self.ms_tasks[ud1].name.."'")
        end
    end
end

function GeometryCache:get(str1)
    return self.ms_cache[str1]
end

GeometryCache = setmetatable({},GeometryCache)
