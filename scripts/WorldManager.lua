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
    
    self.ms_modelCache.plane = Model(GeometryCache:get("plane"))
    
    self.ms_modelCache.rigid = {}
    for i=1,25 do
        local l_model = Model(GeometryCache:get("cone"))
        local l_col = Collision("cone",1.0, 1.0,1.0)
        l_col:setPosition(4.0,1.0+2.0*(i-1),4.0)
        l_col:setFriction(1.0)
        l_model:setCollision(l_col)
        table.insert(self.ms_modelCache.rigid,l_model)
    end
    for i=1,25 do
        local l_disp = math.pow(-1,i%2)
        local l_model = Model(GeometryCache:get("cylinder"))
        local l_col = Collision("cylinder",1.0, 1.0,0.5,1.0)
        l_col:setPosition(4.0+0.25*l_disp,1.0+2.0*(i-1),-4.0+0.25*l_disp)
        l_col:setFriction(1.0)
        l_model:setCollision(l_col)
        table.insert(self.ms_modelCache.rigid,l_model)
    end
    for i=1,25 do
        local l_model = Model(GeometryCache:get("cube"))
        local l_col = Collision("box",10.0, 1.0,1.0,1.0)
        l_col:setPosition(-4.0+0.5*math.pow(-1,i%2),1.0+2.0*(i-1),4.0)
        l_col:setRotation(Quat(0,math.pi*((i-50)/50),0):getXYZW())
        l_col:setFriction(1.0)
        l_model:setCollision(l_col)
        table.insert(self.ms_modelCache.rigid,l_model)
    end
    for i=1,25 do
        local l_disp = math.pow(-1,i%2)
        local l_model = Model(GeometryCache:get("sphere"))
        local l_col = Collision("sphere",0.25, 1.0)
        l_col:setPosition(-4.0+0.25*l_disp,1.0+2.0*(i-1),-4.0+0.25*l_disp)
        l_col:setFriction(1.0)
        l_model:setCollision(l_col)
        table.insert(self.ms_modelCache.rigid,l_model)
    end
    
    self.ms_modelCache.dummy = Model(GeometryCache:get("dummy"))
    self.ms_modelCache.dummy:setPosition(-12.0,0.0,-8.0)
    self.ms_modelCache.dummy:setAnimation(AnimationCache:get("dummy","idle"))
    self.ms_modelCache.dummy:playAnimation()
    
    self.ms_modelCache.wall = Model(GeometryCache:get("plane"))
    self.ms_modelCache.wall:setPosition(32,15,0)
    self.ms_modelCache.wall:setRotation(Quat(0,0,math.piHalf):getXYZW())
    
    -- Add to render
    for _,v in ipairs({ "shadow", "main" }) do
        SceneManager:addModelToScene(v,self.ms_modelCache.plane)
        for _,vv in ipairs(self.ms_modelCache.rigid) do
            SceneManager:addModelToScene(v,vv)
        end
        SceneManager:addModelToScene(v,self.ms_modelCache.dummy)
    end
    SceneManager:addModelToScene("main",self.ms_modelCache.wall)
    SceneManager:addModelToScene("skybox",self.ms_modelCache.skybox)
    
    local l_lights = SceneManager:getLights("main")
    self.ms_lightCache = {
        point = {
            l_lights[2],
            l_lights[3]
        },
        spotlight = l_lights[4]
    }
    
    self.ms_lightCache.spotlight:setPosition(25,15,0)
    
    -- Add prerender event
    addEventHandler("onPreRender",self.onPreRender)
end

function WorldManager.onPreRender()
    local self = WorldManager
    
    -- Update skybox
    self.ms_modelCache.skybox:setPosition(ControlManager:getCameraPosition())
    
    local l_time = getTime()
    local l_sin,l_cos = math.sin(l_time),math.cos(l_time)
    self.ms_lightCache.point[1]:setPosition(30,15+10*l_sin,10*l_cos)
    self.ms_lightCache.point[2]:setPosition(30,15-10*l_sin,-10*l_cos)
    self.ms_lightCache.spotlight:setDirection(math.abs(l_sin),l_cos,0)
end

function WorldManager:getModel(str1)
    return self.ms_modelCache[str1]
end

WorldManager = setmetatable({},WorldManager)
