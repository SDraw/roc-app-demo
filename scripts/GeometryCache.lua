GeometryCache = {}
GeometryCache.__index = GeometryCache

addEvent("onGeometryCacheLoad")
function GeometryCache.init()
    local self = GeometryCache
    
    self.ms_cache = {
        skybox = Geometry("models/skybox.rmf",true),
        plane = Geometry("models/plane.rmf",true),
        cube = Geometry("models/cube.rmf",true),
        cone = Geometry("models/cone.rmf",true),
        cylinder = Geometry("models/cylinder.rmf",true),
        sphere = Geometry("models/icosphere.rmf",true),
        dummy = Geometry("models/dummy.rmf",true)
    }
    self.ms_cacheCount = 0
    for k,v in pairs(self.ms_cache) do
        v:setData("geometry:cache",k)
        self.ms_cacheCount = self.ms_cacheCount+1
    end
    self.ms_cacheResult = 0
    
    addEventHandler("onGeometryLoad",self.onGeometryLoad)
end
addEventHandler("onEngineStart",GeometryCache.init)

function GeometryCache.onGeometryLoad(ud1,bool1)
    local self = GeometryCache
    
    local l_data = ud1:getData("geometry:cache")
    if(l_data) then
        ud1:removeData("geometry:cache")
        if(bool1) then
            self.ms_cacheResult = self.ms_cacheResult+1
            if(self.ms_cacheResult == self.ms_cacheCount) then
                callEvent("onGeometryCacheLoad")
                removeEventHandler("onGeometryLoad",self.onGeometryLoad)
            end
        end
    end
end

function GeometryCache:get(str1)
    return self.ms_cache[str1]
end

GeometryCache = setmetatable({},GeometryCache)
