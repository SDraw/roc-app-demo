WorldManager = {}
WorldManager.__index = WorldManager

function WorldManager.init()
    local self = WorldManager

    self.ms_boundary = {}
    self.ms_boundary[1] = Collision("box",0, 16,100,16)
    self.ms_boundary[1]:setPosition(0,100,16+16)
    self.ms_boundary[2] = Collision("box",0, 16,100,16)
    self.ms_boundary[2]:setPosition(0,100,-16-16)
    self.ms_boundary[3] = Collision("box",0, 16,100,16)
    self.ms_boundary[3]:setPosition(16+16,100,0)
    self.ms_boundary[4] = Collision("box",0, 16,100,16)
    self.ms_boundary[4]:setPosition(-16-16,100,0)
    self.ms_boundary[5] = Collision("box",0, 32,16,32)
    self.ms_boundary[5]:setPosition(0,200+16,0)
    
    self.ms_modelCache = {}
    
    addEventHandler("onGeometryCacheLoad",self.onGeometryCacheLoad)
end
addEventHandler("onEngineStart",WorldManager.init)

function WorldManager.onGeometryCacheLoad()
    local self = WorldManager
    
    -- Create models
    self.ms_modelCache.skybox = Model(GeometryCache:get("skybox"))
    self.ms_modelCache.skybox:setRotation(Quat(0.0,math.pi*1.25,0.0):getXYZW())
    
    --self.ms_modelCache.clouds = Model(GeometryCache:get("clouds"))
    --self.ms_modelCache.clouds:setPosition(0.0,300.0,0.0)
    --self.ms_modelCache.clouds:setScale(10.0,1.0,10.0)
    
    self.ms_modelCache.plane = Model(GeometryCache:get("plane"))
    
    self.ms_modelCache.rigid = {}
    for i=1,25 do
        local l_model = Model(GeometryCache:get("cone"))
        l_model:setPosition(4.0,1.0+2.0*(i-1),4.0)
        local l_col = Collision("cone",1.0, 1.0,1.0)
        l_col:setFriction(1.0)
        l_col:attach(l_model)
        table.insert(self.ms_modelCache.rigid,l_model)
    end
    for i=1,25 do
        local l_disp = math.pow(-1,i%2)
        local l_model = Model(GeometryCache:get("cylinder"))
        l_model:setPosition(4.0+0.25*l_disp,1.0+2.0*(i-1),-4.0+0.25*l_disp)
        local l_col = Collision("cylinder",1.0, 1.0,0.5,1.0)
        l_col:setFriction(1.0)
        l_col:attach(l_model)
        table.insert(self.ms_modelCache.rigid,l_model)
    end
    for i=1,25 do
        local l_model = Model(GeometryCache:get("cube"))
        l_model:setPosition(-4.0+0.5*math.pow(-1,i%2),1.0+2.0*(i-1),4.0)
        l_model:setRotation(Quat(0,math.pi*((i-50)/50),0):getXYZW())
        local l_col = Collision("box",10.0, 1.0,1.0,1.0)
        l_col:setFriction(1.0)
        l_col:attach(l_model)
        table.insert(self.ms_modelCache.rigid,l_model)
    end
    for i=1,25 do
        local l_disp = math.pow(-1,i%2)
        local l_model = Model(GeometryCache:get("sphere"))
        l_model:setPosition(-4.0+0.25*l_disp,1.0+2.0*(i-1),-4.0+0.25*l_disp)
        local l_col = Collision("sphere",0.25, 1.0)
        l_col:setFriction(1.0)
        l_col:attach(l_model)
        table.insert(self.ms_modelCache.rigid,l_model)
    end
    
    self.ms_modelCache.cycloid = {}
    for i=1,36 do
        table.insert(self.ms_modelCache.cycloid,Model(GeometryCache:get("cube")))
    end
    self.ms_cycloidAngle = 0
    
    self.ms_modelCache.dummy = Model(GeometryCache:get("dummy"))
    self.ms_modelCache.dummy:setPosition(-12.0,0.0,-8.0)
    
    -- Set animations
    for _,v in ipairs({ "dummy" }) do
        local l_model = self.ms_modelCache[v]
        if(l_model) then
            local l_animation = AnimationCache:get(v,"idle")
            if(l_animation) then
                l_model:setAnimation(l_animation)
                l_model:playAnimation()
            end
        end
    end
    
    -- Add to render
    for _,v in ipairs({ "shadow", "main" }) do
        RenderManager:addToQueue(v,self.ms_modelCache.plane)
        RenderManager:addToQueue(v,self.ms_modelCache.rigid)
        RenderManager:addToQueue(v,self.ms_modelCache.dummy)
    end
    RenderManager:addToQueue("main",self.ms_modelCache.cycloid)
    
    RenderManager:addToQueue("skybox",self.ms_modelCache.skybox)
    
    -- Add prerender event
    addEventHandler("onPreRender",self.onPreRender)
end

local g_worldCycloidStep = math.pi/18.0
local g_worldCycloidCubeStep = g_worldCycloidStep/16
function WorldManager.onPreRender()
    local self = WorldManager
    
    -- Update skybox
    self.ms_modelCache.skybox:setPosition(ControlManager:getCameraPosition())
    
    -- Update cycloid
    local l_cubeRot = Quat(0,0,0,1)
    self.ms_cycloidAngle  = math.fmod(self.ms_cycloidAngle+g_worldCycloidCubeStep*(60.0/RenderManager:getFPS()),math.pi2)
    for k,v in ipairs(self.ms_modelCache.cycloid) do
        local l_angle = math.fmod(self.ms_cycloidAngle+g_worldCycloidStep*k,math.pi2)
        v:setPosition(
            10.0*(math.cos(l_angle)+math.cos(7*l_angle)/7),
            10+10.0*(math.sin(l_angle)-math.sin(7*l_angle)/7),
            18.0
        )
        l_cubeRot:setEuler(0,0,l_angle)
        v:setRotation(l_cubeRot:getXYZW())
        local l_scale = math.abs(math.cos(l_angle*8.0))
        v:setScale(l_scale,l_scale,l_scale)
    end
end

function WorldManager:getModel(str1)
    return self.ms_modelCache[str1]
end

WorldManager = setmetatable({},WorldManager)
