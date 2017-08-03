AnimationCache = {}
AnimationCache.__index = AnimationCache

function AnimationCache.init()
    local self = AnimationCache
    
    self.ms_cache = {
        dummy = {
            idle = Animation("animations/dummy_idle.raf"),
            walk = Animation("animations/dummy_walk.raf")
        }
    }
end
addEventHandler("onEngineStart",AnimationCache.init)

function AnimationCache:get(str1,str2)
    return (self.ms_cache[str1] and self.ms_cache[str1][str2] or false)
end

AnimationCache = setmetatable({},AnimationCache)
